//
//  JobDetail.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct JobDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var job: Job

    var body: some View {
        ComponentList()
            .navigationTitle(job.name)
            .navigationBarTitleDisplayMode(.large)
            }
}

struct JobDetail_Previews: PreviewProvider {
    static var previews: some View {
        JobDetail(job: jobs[0])
    }
}
