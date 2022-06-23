//
//  AirFragTests.swift
//  AirFragTests
//
//  Created by Daniel on 12/06/2022.
//

import XCTest
import CryptoKit
@testable import AirFrag

class AirFragTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testKeyCreation() throws {
        
        let private_key_string = "6d8fa0b60e618196860ce850024d228b9a2fb07e8e4a1ce300770378"
        let sym_key_string = "496c0133a5b4b6a26492b5a462e29ccc936ed1c7b9a19dce56ffdc2a57e013a8"
        let private_key_data = private_key_string.hexadecimal
        let sym_key_data = sym_key_string.hexadecimal
        
        let myAccessory = try Accessory(name: "Test1", key: private_key_string.hexadecimal!, symKey: sym_key_string.hexadecimal!)
        
        
        
    }
    
    func testPlugin() throws {
        
        //let testing = try Fabricator()
        let pluginManager = MailPluginManager()
        //let localPluginURL = Bundle.main.url(forResource: "OpenHaystackMail", withExtension: "mailbundle")!
        
        if pluginManager.isMailPluginInstalled != true {
            if pluginManager.askForPermission(){
                try pluginManager.installMailPlugin()
            } else {
                exit(1)
            }
        }
    }
    
    func testKeyGeneration() throws {
        
        guard let key = BoringSSL.generateNewPrivateKey() else {
            throw KeyError.keyGenerationFailed
        }
        
        let key_string = key.hexEncodedString()
        
        let key_data = key_string.hexadecimal
        let symKey = SymmetricKey(size: .bits256)
        let keyb64 = symKey.withUnsafeBytes {
            return Data(Array($0))
        }
        let symKey2 = SymmetricKey(data: keyb64)
        
        XCTAssertEqual(symKey2, symKey)
        XCTAssertEqual(key, key_data)
    }

}
