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
    @EnvironmentObject var jobInfo: LocalData // finds the LocalData object created in JobList.swift
    @State private var images: [UIImage] = [UIImage]() // might use to make pdf

    init(name: String) {
        self.ownerName = name
        
    }

    func updateJobs() {
        let db = Firestore.firestore() // update current jobs if new photos have been uploaded
        for i in (0...10) { // update to change amount of updated jobs
            let job = jobInfo.jobArr[i]
            db.collection("owners/" + job.name + "/pics").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let dict = document.data()
                            for doc in dict {
                                if let idx = self.jobInfo.jobArr[i].componentList.firstIndex(where: { doc.value as! String == $0.name } ) {
                                    self.jobInfo.jobArr[i].componentList[idx].hasPhoto = true
                                }
                            }
                        }
                    }
            }
        }
    }

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
                HStack {
                    UploadButton(ownerName: ownerName, selectedImages: [UIImage](), uploadTypeElectrical: true)
                        .padding(EdgeInsets(top: 0, leading: 3, bottom: 10, trailing: 1))
                    UploadButton(ownerName: ownerName, selectedImages: [UIImage](), uploadTypeElectrical: false)
                        .padding(EdgeInsets(top: 0, leading: 1, bottom: 10, trailing: 15))
                }
            }
        }
        .onAppear(perform: {
            updateJobs()
        })
    }
}

struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentList(name: "John A")
    }
}
