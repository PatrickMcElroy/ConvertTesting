//
//  MatchingView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/2/21.
//

import SwiftUI
import Firebase

struct MatchingView: View {
    @State private var action: Int? = 0
    @State var images: [UIImage]
    @State private var nextText : String = "Next"
    @State private var viewComponents: [Component] = components
    @State private var componentArray: [[String]]
    @State var currentImage = 0
    var ownerName : String
    var uploadTypeElectrical: Bool // false for panel, true for electrical
    
    init(images: [UIImage], ownerName: String, uploadTypeElectrical: Bool) {
        self.ownerName = ownerName
        self.images = images
        self.uploadTypeElectrical = uploadTypeElectrical
        componentArray = [[String]](repeating: [String](), count: images.count)
    }
    
    var body: some View {
        NavigationLink(destination: ContentView(), tag: 1, selection: $action) {
            EmptyView()
        }
        Image(uiImage: (images[currentImage]))
            .resizable()
            .frame(minWidth: 0, idealWidth: 100, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 300, alignment: .center)
            .navigationBarTitle("Match Your Photos")
            .shadow(radius: 7)
            .cornerRadius(10)
            .padding()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) { // TODO: make scrolling more user friendly (make closer together so less scroll, make it easier to scroll without clicking, etc.)
                ForEach(viewComponents.filter({$0.electricalComponent == uploadTypeElectrical})) { component in
                    Button(action: {
//                        if let idx = self.viewComponents.firstIndex(where: { $0.name == component.name}) {
//                            self.viewComponents[idx].isSelected.toggle()
                            if (!self.componentArray[currentImage].contains(component.name)) {
                                self.componentArray[currentImage].append(component.name)
                            }
                            else {
                                self.componentArray[currentImage].removeAll(where: { $0 == component.name })
                            }
//                        }
                    }) {
                        Text(component.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 300, height: 40, alignment: .center)
                            .background(componentArray[currentImage].contains(component.name) ? Color.green : Color.white)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .shadow(radius: 4)
                            .colorMultiply(component.hasPhoto && !componentArray[currentImage].contains(component.name) ? Color.init(UIColor(red: 0.6, green: 0.9, blue: 0.6, alpha: 1)) : .white)
                        
                    }
//                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                    }
                // TODO add some kind of "Other" option
                        
                }
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        currentImage -= 1
                        if (currentImage < images.count - 1) {
                            nextText = "Next"
                        }
                    }, label: {
                        Text("Previous")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color.gray)
                            .shadow(radius: 7)
                            .cornerRadius(10)
                    })
                    .isHidden(currentImage == 0)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 10))
                    Spacer()
                    Button(action: {
                        currentImage += 1
                        for i in (0...viewComponents.count - 1) {
                            if (componentArray[currentImage-1].contains(viewComponents[i].name)) {
                            }
                        } // TODO: change so that hasPhoto is changed when done is clicked and that there is a back button to take you back to previous photos (and show what they were marked as)
                        if (currentImage == images.count - 1) {
                            nextText = "Done"
                        }
                        else if (currentImage == images.count) {
                            currentImage -= 1 // TODO: is there a better way to fix index out of range error?
                            let db = Firestore.firestore()
                            for i in (0...images.count - 1) {
                                for component in componentArray[i] {
                                    
                                    let storage = Storage.storage()
                                    let storageRef = storage.reference()
                                    let imageDestRef = storageRef.child("images/" + ownerName + component + ".jpg")
                                    
                                    let data = images[i].jpegData(compressionQuality: 0.1)
                                    
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
                                    var ref: DocumentReference? = nil
                                    ref = db.collection("owners/" + ownerName + "/pics").addDocument(data: [
                                        "url": downloadURL.absoluteString,
                                        "componentName": component,
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
                                        "componentName": component,
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
                            }
                            }
                            // go back to main view
                            self.action = 1
                        }
                    }) {
                        Text(nextText)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color.gray)
                            .shadow(radius: 7)
                            .cornerRadius(10)
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 30))
                }
            }
        }
        }
    }


struct MatchingView_Previews: PreviewProvider {
    static var imageArr: [UIImage] = [UIImage(systemName: "plus")!]

    static var previews: some View {
        
        MatchingView(images: imageArr, ownerName: "John A", uploadTypeElectrical: true)
    }
}
