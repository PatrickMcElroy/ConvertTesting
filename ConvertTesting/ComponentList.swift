//
//  ComponentList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

class ViewComponents: ObservableObject {
    @Published var arr = [Component(name: "Inside of AC Disconnect"), Component(name: "Outside of AC Disconnect"), Component(name: "Inside of Main Panel"), Component(name: "Outside of Main Panel"), Component(name: "Finished Panels"), Component(name: "Optimizer or Microinverter Wiring"), Component(name: "Inside of Soladeck Box"), Component(name: "Attic Conduit Run"), Component(name: "Outside Run To Inverter")]
}

struct ComponentList: View {
    var ownerName : String
    @State var viewHidden = false
    @ObservedObject var viewComponents = ViewComponents()
    var body: some View {
        ScrollView {
            ForEach(self.viewComponents.arr.filter({ !$0.hasPhoto })) { component in
                
                ComponentView(componentName: component.name, ownerName: ownerName, viewComponents: self.viewComponents)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
        }
    }
}

struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentList(ownerName: "John A")
    }
}
