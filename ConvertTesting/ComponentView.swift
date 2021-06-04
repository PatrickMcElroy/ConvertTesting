//
//  ComponentView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase
import Photos

struct ComponentView: View {
    var componentName: String
    var ownerName: String
    var hasPhoto: Bool = false
    @ObservedObject var viewComponents: ViewComponents
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text(componentName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            Spacer()
            HStack() {
                Button(action: {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized {
                            showPhotoPicker = true
                        }
                    })
                }) {
                    Text(!hasPhoto ? "Upload Photo" : "Add Photos")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 250, height: 40, alignment: .center)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                }
                .fullScreenCover(isPresented: $showPhotoPicker) {
                    PhotoPicker(filter: .images, limit: 0) { results in
                      PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                        if let error = errorOrNil {
                          print(error)
                        }
                        if let images = imagesOrNil {
                          if let first = images.first {
                            selectedImage = first
                            
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            let imageDestRef = storageRef.child("images/image.jpg") // TODO: make this change dynamically? 
                            
                            let data = selectedImage!.jpegData(compressionQuality: 0.1)
                            
                            let uploadTask = imageDestRef.putData(data!, metadata: nil) { (metadata, error) in
                              guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                              }
                              // Metadata contains file metadata such as size, content-type.
                              // You can also access to download URL after upload.
                              imageDestRef.downloadURL { (url, error) in
                                guard let downloadURL = url else {
                                  // Uh-oh, an error occurred!
                                  return
                                }
                                // upload download url to firestore database
                                
                                let db = Firestore.firestore()
                                var ref: DocumentReference? = nil
                                ref = db.collection("owners/" + ownerName + "/pics").addDocument(data: [
                                    "url": downloadURL.absoluteString,
                                    "componentName": componentName,
                                    "owner": ownerName
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added with ID: \(ref!.documentID)")
                                    }
                                }
                                ref = db.collection("pics").addDocument(data: [
                                    "url": downloadURL.absoluteString,
                                    "componentName": componentName,
                                    "owner": ownerName
                                ]) { err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added with ID: \(ref!.documentID)")
                                    }
                                }
                              }
                            }
                            
                            uploadTask.observe(.progress) { snapshot in
                              // Upload reported progress
                              let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                / Double(snapshot.progress!.totalUnitCount)
                            }

                            uploadTask.observe(.success) { snapshot in
                              // Upload completed successfully
                                
                            }

                            uploadTask.observe(.failure) { snapshot in
                              if let error = snapshot.error as? NSError {
                                switch (StorageErrorCode(rawValue: error.code)!) {
                                case .objectNotFound:
                                  // File doesn't exist
                                    print("onf")
                                  break
                                case .unauthorized:
                                  // User doesn't have permission to access file
                                    print("un")
                                  break
                                case .cancelled:
                                  // User canceled the upload
                                  break

                                /* ... */

                                case .unknown:
                                  // Unknown error occurred, inspect the server response
                                    print("unk")
                                  break
                                default:
                                  // A separate error occurred. This is a good place to retry the upload.
                                  break
                                }
                              }
                            }

                            
                            if let idx = self.viewComponents.arr.firstIndex(where: { $0.name == componentName}) {
                                self.viewComponents.arr[idx].hasPhoto = true
                            }
                            
                          }
                        }
                      }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            
                Button(action: {
                    if let idx = self.viewComponents.arr.firstIndex(where: { $0.name == componentName}) {
                        self.viewComponents.arr[idx].hasPhoto = true
                    }
                })
                {
                    Text("N/A")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .frame(width: 60, height: 40, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
                        .isHidden(hasPhoto, remove: true)
                }
            }
        }
        .frame(width: 350, height: 100, alignment: .center)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
            
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView(componentName: "Inside of AC Disconnect", ownerName: "John A", viewComponents: ViewComponents())
    }
}
