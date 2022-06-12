//
//  replay.swift
//  AirFrag
//
//  Created by Daniel on 11/06/2022.
//

import Foundation
import CryptoKit


public class Fabricator {
    
    //let deviceId: String
    //var keys = [FindMyKey]()
    //var catalinaBigSurKeyFiles: [Data]?

    /// KeyHash: Report results.
   // var reports: [FindMyReport]?

    //var decryptedReports: [FindMyLocationReport]?
    
    internal init (){
        print("test")
        
        let plist = Bundle.main.url(forResource: "sampleKeys", withExtension:"plist")!
            do {
                let data = try Data(contentsOf: plist)
                //let plist = try Data(contentsOf: Bundle(for: Self.self).url(forResource: "sampleKeys", withExtension: "plist")!)
                let result = try PropertyListDecoder().decode([FindMyDevice].self, from: data)
                let keys = result.first!.keys
            } catch { print(error) }
        
        print("Done")
        
//        do {
//            let plist = try Data(contentsOf: Bundle(for: Self.self).url(forResource: "sampleKeys", withExtension: "plist")!)
//            let devices = try PropertyListDecoder().decode([FindMyDevice].self, from: plist)
//
//            let keys = devices.first!.keys
//            let key = keys[0]
//        } catch {
//            print("lol")
//        }
        
//                for key in keys {
//                    let publicKey = key.advertisedKey
//                    var sha = SHA256()
//                    sha.update(data: publicKey)
//                    let digest = sha.finalize()
//                    let hashedKey = Data(digest)
//
    }
    
//    func fetch_location() {
//        continue
//    }
}
