//
//  JobList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct JobList: View {

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

