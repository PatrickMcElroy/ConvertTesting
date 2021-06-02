//
//  MatchingView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/2/21.
//

import SwiftUI
import UIKit

struct MatchingView: View {
    @State var images : [UIImage]
    @State private var nextText : String = "Next"
    @State private var viewComponents : [Component] = components
    private var uploads : [UIImage]
    
    init(images : [UIImage]) {
        self.images = images
        self.uploads = images
    }
    
    var body: some View {
        Image(uiImage: (images.last ?? UIImage(systemName: "plus"))!)
            .resizable()
            .frame(minWidth: 0, idealWidth: 100, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 300, alignment: .center)
            .navigationBarTitle("Match Your Photos")
            .shadow(radius: 7)
            .cornerRadius(10)
            .padding()
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewComponents) { component in
                    Button(action: {
                        if let idx = self.viewComponents.firstIndex(where: { $0.name == component.name}) {
                            self.viewComponents[idx].hasPhoto.toggle()
                        }
                    }) {
                        Text(component.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 300, height: 40, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                            .shadow(radius: 4)
                            .colorMultiply(component.hasPhoto ? .green : .white)
                        
                    }
                    .padding()
                    }
                        
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        images.removeLast()
                        if (images.count == 1) {
                            nextText = "Done"
                        }
                        if (images.count == 0) {
                            // do all the image uploading
                        }
                    }) {
                        Text(nextText)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .frame(width: 110, height: 50, alignment: .center)
                            .background(Color.gray)
                            .shadow(radius: 7)
                            .cornerRadius(10)
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 30))
                }
            }
        }
    }


struct MatchingView_Previews: PreviewProvider {
    static var imageArr: [UIImage] = [UIImage(systemName: "plus")!]

    static var previews: some View {
        
        MatchingView(images: imageArr)
    }
}
