//
//  MatchingView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/2/21.
//

import SwiftUI
import Firebase

struct MatchingView: View {
    @State private var action : Int? = 0
    @State var images : [UIImage]
    @State private var nextText : String = "Next"
    @State private var viewComponents : [Component] = components
    private var uploads : [UIImage]
    @State private var componentArray : [[String]]
    var ownerName : String
    
    init(images : [UIImage], ownerName : String) {
        self.ownerName = ownerName
        self.images = images
        self.uploads = images
        componentArray = [[String]](repeating: [String](), count: images.count)
    }
    
    var body: some View {
        NavigationLink(destination: ContentView(), tag: 1, selection: $action) {
            EmptyView()
        }
        Image(uiImage: (images.last ?? UIImage()))
            .resizable()
            .frame(minWidth: 0, idealWidth: 100, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 300, alignment: .center)
            .navigationBarTitle("Match Your Photos")
            .shadow(radius: 7)
            .cornerRadius(10)
            .padding()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewComponents) { component in
                    Button(action: {
                        if let idx = self.viewComponents.firstIndex(where: { $0.name == component.name}) {
                            self.viewComponents[idx].isSelected.toggle()
                        }
                        self.componentArray[images.count - 1].append(component.name)
                    }) {
                        Text(component.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 300, height: 40, alignment: .center)
                            .background(component.isSelected ? Color.green : Color.white)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                            .shadow(radius: 4)
                            .colorMultiply(component.hasPhoto && !component.isSelected ? Color.init(UIColor(red: 0.6, green: 0.9, blue: 0.6, alpha: 1)) : .white)
                        
                    }
                    .padding()
                    }
                        
                }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        images.removeLast()
                        for i in (0...viewComponents.count - 1) {
                            if (viewComponents[i].isSelected) {
                                viewComponents[i].hasPhoto = true
                            }
                            viewComponents[i].isSelected = false
                        }
                        if (images.count == 1) {
                            nextText = "Done"
                        }
                        if (images.count == 0) {
                            let db = Firestore.firestore()
                            for i in (0...uploads.count - 1) {
                                for component in componentArray[i] {
                                    
                                    let storage = Storage.storage()
                                    let storageRef = storage.reference()
                                    let imageDestRef = storageRef.child("images/" + String(i) + ".jpg")
                                    
                                    let data = uploads[i].jpegData(compressionQuality: 0.1) // TODO: change the compression quality? (everywhere this is used)
                                    
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
                            .frame(width: 110, height: 50, alignment: .center)
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
        
        MatchingView(images: imageArr, ownerName: "John A")
    }
}
