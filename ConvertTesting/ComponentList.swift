//
//  ComponentList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct ComponentList: View {
    var body: some View {
        ScrollView {
            ComponentView(componentName: "Inside of AC Disconnect")
                .padding()
            ComponentView(componentName: "Outside of AC Disconnect")
                .padding()
        }
    }
}

struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentList()
    }
}
