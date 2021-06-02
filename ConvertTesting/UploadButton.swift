//
//  UploadButton.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/2/21.
//

import SwiftUI
import Photos
import Firebase

struct UploadButton: View {
    var ownerName : String
    @State private var action: Int? = 0
    @State private var showPhotoPicker = false
    @State private var selectedImage: UIImage? = nil
    @State var selectedImages: [UIImage]

    var body: some View {
        NavigationLink(destination: MatchingView(images: selectedImages), tag: 1, selection: $action) {
            EmptyView()
        }
        Button(action: {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    showPhotoPicker = true
                }
            })
        }){
           Text("Add Photo Batch")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .frame(minWidth: 0, maxWidth: 275, minHeight: 0, maxHeight: 75)
            .background(Color.gray)
            .cornerRadius(20)
        }.buttonStyle(PlainButtonStyle())
        .shadow(radius: 7)
        .fullScreenCover(isPresented: $showPhotoPicker) {
            PhotoPicker(filter: .images, limit: 0) { results in
              PhotoPicker.convertToUIImageArray(fromResults: results) { (imagesOrNil, errorOrNil) in
                if let error = errorOrNil {
                  print(error)
                }
                if let images = imagesOrNil {
                    selectedImages = images
                    self.action = 1
                }
              }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct UploadButton_Previews: PreviewProvider {
    static var previews: some View {
        UploadButton(ownerName: "John A", selectedImages: [UIImage]())
    }
}
