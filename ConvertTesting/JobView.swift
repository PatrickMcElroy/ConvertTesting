//
//  JobView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct JobView: View {
    @State private var action: Int? = 0
    var job: Job
    
    
    var body: some View {
        NavigationLink(destination: JobDetail(job: job), tag: 1, selection: $action) {
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
                        .background(Color.black)
                        .cornerRadius(15)
                    Spacer() // TODO: make this a different color depending on job completion
                }
                .padding(EdgeInsets(top: 15, leading: 30, bottom: 0, trailing: 0))
                VStack(alignment: .leading) {
                    Text(job.name)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    Link(job.address, destination: URL(string: "comgooglemaps://?daddr=" +  job.address.replacingOccurrences(of: " ", with: "+")) ?? URL(string: "comgooglemaps://")!) // TODO: maybe underline this? need a label but ask about how it looks
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Spacer()
                }
                .padding(EdgeInsets(top: 18, leading: 5, bottom: 0, trailing: 0))
                Spacer()
                VStack {
                    Text(job.installationDate)
                        .font(.body)
                        .fontWeight(.thin)
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 21, leading: 0, bottom: 0, trailing: 0))
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

struct JobView_Previews: PreviewProvider {
    static var previews: some View {
        JobView(job: jobs[0])
    }
}
