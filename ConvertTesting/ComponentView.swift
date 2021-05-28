//
//  ComponentView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct ComponentView: View {
    var componentName: String
    var body: some View {
        VStack {
            HStack {
                Text(componentName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 0))
                Spacer()
            }
            Spacer()
            HStack() {
                Text("Upload Photo")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(width: 250, height: 40, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                Text("N/A")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                    .frame(width: 60, height: 40, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .frame(width: 350, height: 100, alignment: .center)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
            
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView(componentName: "Inside of AC Disconnect")
    }
}
