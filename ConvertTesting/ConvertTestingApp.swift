//
//  ConvertTestingApp.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI
import Firebase

@main
struct ConvertTestingApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ConvertTestingApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
