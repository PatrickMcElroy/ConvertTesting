//
//  JobList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase

struct JobList: View {
    @StateObject var jobInfo = LocalData() // data object that fetches from firestore at app launch
    
    func updateJobs() {
        jobInfo.jobArr = newJobs // initialize the array with all jobs loaded in JobData.swift

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
            NavigationView {
                ScrollView {
                    ForEach(jobInfo.jobArr) { job in
                        JobView(jobIndex: jobInfo.jobArr.firstIndex(of: job) ?? jobInfo.jobArr.startIndex)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Upcoming Jobs")
                .navigationBarTitleDisplayMode(.large)
                .background(Color.white)
            }
            .environmentObject(jobInfo)
            .onAppear(perform: updateJobs)
        
        // TODO: add a way to search or enter a job into the navigation bar
        
    }
}

struct JobList_Previews: PreviewProvider {
    static var previews: some View {
        JobList()
    }
}

