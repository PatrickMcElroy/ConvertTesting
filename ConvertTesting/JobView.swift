//
//  JobView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct JobView: View {
    @EnvironmentObject var jobInfo: LocalData // finds the LocalData object created in JobList.swift
    @State private var action: Int? = 0 // state variable used to trigger navigation change
    @State var jobIndex: Int // which job is being displayed in this view
    
    var body: some View {
        NavigationLink(destination: JobDetail(job: jobInfo.jobArr[jobIndex]), tag: 1, selection: $action) {
            EmptyView()
        }
        Button(action: {
            self.action = 1
        })
        {
            HStack {
                VStack {
                    Text("")
                        .frame(minWidth: 0, maxWidth: 16, minHeight: 0, maxHeight: 60)
                        .background(jobInfo.jobArr[jobIndex].componentList.filter({
                                                                !$0.hasPhoto}).isEmpty ? Color.green : Color.yellow)
                        .cornerRadius(15)
                    Spacer()
                }
                .animation(.default)
                .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 0))
                VStack(alignment: .leading) {
                    Text(jobInfo.jobArr[jobIndex].name)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Link(jobInfo.jobArr[jobIndex].address, destination: URL(string: "comgooglemaps://?daddr=" +  jobInfo.jobArr[jobIndex].address.replacingOccurrences(of: " ", with: "+")) ?? URL(string: "comgooglemaps://")!)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                    Spacer()
                }
                .padding(EdgeInsets(top: 18, leading: 5, bottom: 0, trailing: 0))
                Spacer()
                VStack {
                    Text(jobInfo.jobArr[jobIndex].installationDate)
                        .font(.body)
                        .fontWeight(.thin)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 21, leading: 0, bottom: 0, trailing: 0))
                    Link(destination: URL(string: "tel:" + jobInfo.jobArr[jobIndex].phone.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: ""))!) {
                        Image(systemName: "phone")
                            .resizable()
                            .frame(minWidth: 0, maxWidth: 25, minHeight: 0, maxHeight: 25)
                    }
                    Spacer()
                }
                Image("arrow")
                    .resizable()
                    .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 50)
                    .rotationEffect(.degrees(-180))
            }
            .frame(minWidth: 0, maxWidth: 400, minHeight: 125, maxHeight: 125)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 4)
            
            // TODO: add a way to call each homeowner (blue phone link?)
        }

    }
}

//struct JobView_Previews: PreviewProvider {
//    static var previews: some View {
//        JobView(job: jobs[0])
//    }
//}
