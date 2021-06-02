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
    
    var body: some View {
        Image(uiImage: (images.last ?? UIImage(systemName: "plus"))!)
            .resizable()
            .frame(minWidth: 0, idealWidth: 100, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 300, alignment: .center)
            .navigationBarTitle("Match Your Photos")
            .shadow(radius: 7)
            .cornerRadius(10)
        Spacer()
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var imageArr: [UIImage] = [UIImage(systemName: "plus")!]

    static var previews: some View {
        
        MatchingView(images: imageArr)
    }
}
