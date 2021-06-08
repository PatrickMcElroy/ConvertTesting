//
//  PDFCreator.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/4/21.
//

import Foundation
import Firebase
import SwiftUI


func uploadPDF(ownerName: String, image: UIImage = UIImage(), componentName: String) -> Void {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageDestRef = storageRef.child("images/" + ownerName + componentName + ".pdf")
    
    let data = createFlyer(image: image, componentName: componentName)
    
    let uploadTask = imageDestRef.putData(data, metadata: nil) { (metadata, error) in
      guard let metadata = metadata else {
        // Uh-oh, an error occurred!
        return
      }
      // Metadata contains file metadata such as size, content-type.
      // You can also access to download URL after upload.
      imageDestRef.downloadURL { (url, error) in
        guard let downloadURL = url else {
          // Uh-oh, an error occurred!
          return
        }
        // upload download url to firestore database
        
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("owners/" + ownerName + "/pics").addDocument(data: [
            "url": downloadURL.absoluteString,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        ref = db.collection("pics").addDocument(data: [
            "url": downloadURL.absoluteString,
            "owner": ownerName
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
      }
    }
    
}

func createFlyer(ownerName: String = "", image: UIImage = UIImage(), componentName: String = "") -> Data {
  // 1
  let pdfMetaData = [
    kCGPDFContextCreator: "Component PDF",
    kCGPDFContextAuthor: "Convert Solar"
  ]
  let format = UIGraphicsPDFRendererFormat()
  format.documentInfo = pdfMetaData as [String: Any]

  // 2
  let pageWidth = 8.5 * 72.0
  let pageHeight = 11 * 72.0
  let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

  // 3
  let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
  // 4
  let data = renderer.pdfData { (context) in
    // 5
    context.beginPage()
    // 6
    let attributes = [
      NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
    ]
    let imagePosition = CGRect(x: 0, y: 0, width: 50, height: 50)
    image.draw(in: imagePosition)
    let text = componentName
    text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
  }

  return data
}


//    func updateComponents() {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        for component in components {
//            let imageRef = storageRef.child("images/" + ownerName + component.name + ".jpg")
//
//            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//              if let error = error {
//                // Uh-oh, an error occurred!
//              } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//                uploadPDF(ownerName: ownerName, image: image!, componentName: component.name)
//              }
//            }
//        }
    // test code
//    }
