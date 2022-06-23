//
//  ContentView.swift
//  AirFrag
//
//  Created by Daniel on 12/06/2022.
//

import SwiftUI
import CryptoKit

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

func testKeyCreation() throws {
    
    let private_key_string = "6d8fa0b60e618196860ce850024d228b9a2fb07e8e4a1ce300770378"
    let sym_key_string = "496c0133a5b4b6a26492b5a462e29ccc936ed1c7b9a19dce56ffdc2a57e013a8"
    let private_key_data = private_key_string.hexadecimal
    let sym_key_data = sym_key_string.hexadecimal
    
    let myAccessory = try Accessory(name: "Test1", key: private_key_string.hexadecimal!, symKey: sym_key_string.hexadecimal!)
    
}

func testKeyRetreval() {
    
    let test_key = "6d8fa0b60e618196860ce850024d228b9a2fb07e8e4a1ce300770378"
    let data_key = test_key.hexadecimal!
    
    let fetcher = query(forHashes: [data_key], start: <#T##NSDate#>, duration: <#T##Double#>, searchPartyToken: <#T##NSData#>, completion: <#T##(NSData?) -> Void#>)

    
}


struct ContentView: View {
    
    internal init() {
        print("Test")

        
        do {
            
            try testKeyCreation()
            
            let test_accessories = [try Accessory(name: "test"), try Accessory(name: "test2"), try Accessory(name: "test3")]
            let myFindMyController = FindMyController()
            
            let myAccessoryController = AccessoryController(accessories: test_accessories, findMyController: myFindMyController)
            
            let myView = MainView(controller: myAccessoryController)
            //let myMail = OpenHaystackPluginService()
            //OpenHaystackPluginService.sharedService()
            
            //try myAccessoryController.export(accessories: test_accessories)
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
