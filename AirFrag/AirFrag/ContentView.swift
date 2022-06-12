//
//  ContentView.swift
//  AirFrag
//
//  Created by Daniel on 12/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    internal init() {
        print("Test")
        let testing = Fabricator()
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
