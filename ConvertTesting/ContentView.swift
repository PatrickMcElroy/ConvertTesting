//
//  ContentView.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        JobList()
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .navigationBarTitle("")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
