//
//  ComponentList.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase
import Combine

class ViewComponents: ObservableObject {
    @Published var arr = components
}

struct ComponentList: View {
    var ownerName : String
    let didChange = PassthroughSubject<ComponentList, Never>()
    @State var viewHidden = false
    @ObservedObject var viewComponents = ViewComponents()
    @State private var displayComponents = [Component]()
    
    init(name: String) {
        self.ownerName = name
        updateComponents()
        // TODO: make it so loading happens on the main screen when you load the app, and stuff is done locally after that
    }
    func updateComponents() {
        let db = Firestore.firestore()
        db.collection("owners/" + ownerName + "/pics").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dict = document.data()
                        for doc in dict {
                            if let idx = self.viewComponents.arr.firstIndex(where: { doc.value as! String == $0.name } ) {
                                self.viewComponents.arr[idx].hasPhoto = true
                            }
                        }
                    }
                }
        }
    }
    var body: some View {
        ZStack {
            ScrollView {
                ForEach(self.viewComponents.arr.filter({ !$0.hasPhoto })) { component in
                    
                    ComponentView(componentName: component.name, ownerName: ownerName, viewComponents: self.viewComponents)
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                }
            }
            .animation(.default)
            VStack {
                Spacer()
                UploadButton(ownerName: ownerName, selectedImages: [UIImage]())
                    .padding()
            }
        }
    }
}

struct ComponentList_Previews: PreviewProvider {
    static var previews: some View {
        ComponentList(name: "John A")
    }
}
