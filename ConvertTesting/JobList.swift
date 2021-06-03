//
//  JobList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase

struct JobList: View {
    
//    init(name: String) {
//        updateJobs()
//    }
//    func updateJobs() {
//        let db = Firestore.firestore()
//        db.collection("owners/" + ownerName + "/pics").getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        let dict = document.data()
//                        for doc in dict {
//                            if let idx = self.viewComponents.arr.firstIndex(where: { doc.value as! String == $0.name } ) {
//                                self.viewComponents.arr[idx].hasPhoto = true
//                            }
//                        }
//                    }
//                }
//        }
//    }

    var body: some View {
            NavigationView {
                ScrollView {
                    ForEach(newJobs) { job in
                        JobView(job: job)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Upcoming Jobs")
                .navigationBarTitleDisplayMode(.large)
                .background(Color.white)
            }
        
    }
}

struct JobList_Previews: PreviewProvider {
    static var previews: some View {
        JobList()
    }
}

