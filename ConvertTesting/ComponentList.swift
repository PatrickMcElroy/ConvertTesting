//
//  ComponentList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase
import Combine
import PDFKit

struct ComponentList: View {
    var ownerName : String
    @EnvironmentObject var jobInfo: LocalData
    @State private var images: [UIImage] = [UIImage]()
    
    init(name: String) {
        self.ownerName = name
        
    }

    
//    func updateComponents() {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        for component in components {
//            let imageRef = storageRef.child("images/" + ownerName + component.name + ".jpg")
//
//            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//              if let error = error {
//                // Uh-oh, an error occurred!
//              } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//                uploadPDF(ownerName: ownerName, image: image!, componentName: component.name)
//              }
//            }
//        }
        //TODO: move code to upload PDF
//    }
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.jobInfo.jobArr.first(where: { $0.name == ownerName })?.componentList.filter({ !$0.hasPhoto }) ?? [Component]()) { component in
                    
                    ComponentView(componentName: component.name, ownerName: ownerName, hasPhoto: false)
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
                Text("Completed")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                ForEach(self.jobInfo.jobArr.first(where: { $0.name == ownerName })?.componentList.filter({ $0.hasPhoto }) ?? [Component]()) { component in
                    
                    ComponentView(componentName: component.name, ownerName: ownerName, hasPhoto: true)
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
            }
            VStack {
//                Button(action: {uploadPDF(ownerName: ownerName, images: image)}, label: {
//                    Text("Upload")
//                })
                Spacer()
                UploadButton(ownerName: ownerName, selectedImages: [UIImage]())
                    .padding()
            }
        }
    }
}

struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentList(name: "John A")
    }
}
