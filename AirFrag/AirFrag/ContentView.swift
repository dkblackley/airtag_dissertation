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
        
        //let pluginManager = MailPluginManager()
    
        
        do {
            //let testing = try Fabricator()
            
//            if pluginManager.isMailPluginInstalled != true {
//                if pluginManager.askForPermission(){
//                    try pluginManager.installMailPlugin()
//                } else {
//                    exit(1)
//                }
//            }
            
            //let localPluginURL = Bundle.main.url(forResource: "OpenHaystackMail", withExtension: "mailbundle")!
            
            let test_accessories = [try Accessory(name: "test"), try Accessory(name: "test2"), try Accessory(name: "test3")]
            let myFindMyController = FindMyController()
            
            let myAccessoryController = AccessoryController(accessories: test_accessories, findMyController: myFindMyController)
            
            let myView = MainView(controller: myAccessoryController)
            
            try myAccessoryController.export(accessories: test_accessories)
            myView.installMailPlugin()
            myView.checkPluginIsRunning(silent: false, nil)
            myView.downloadLocationReports()
            
            
            
            
            print("Done")
            
        } catch {print(error)}
        
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
