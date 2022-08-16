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
    
    let private_key_string = "0f1aac032440a25d479b749efafdcb3a570f2e8b4728c0f67ae3b83a"
    let sym_key_string = "82e3fac54317ba33110ff25907fc0e7721de189d1f83adbf9952f1945d2e266f"
    let private_key_data = private_key_string.hexadecimal
    let sym_key_data = sym_key_string.hexadecimal
    
    let myAccessory = try Accessory(name: "Test1", key: private_key_string.hexadecimal!, symKey: sym_key_string.hexadecimal!)
    
    print(try myAccessory.getActualPublicKey().hexEncodedString())
    print(try myAccessory.getAdvertisementKey().hexEncodedString())
    
}

func testKeyRetreval(Acontroller: AccessoryController) {
    
    //let test_key = "6d8fa0b60e618196860ce850024d228b9a2fb07e8e4a1ce300770374"
    //let test_key = String("c72c30f688c1b2a57879becf9019d8c86d26c047ec340bf07681d797".reversed())
    let test_key = "c72c30f688c1b2a57879becf9019d8c86d26c047ec340bf07681d797"
    let data_key = test_key.hexadecimal!
    let current_date = NSDate(timeIntervalSinceNow: 0)
    
    var sha = SHA256()
    sha.update(data: data_key)
    let digest = sha.finalize()

    let public_key = Data(digest).base64EncodedString()
    
    let fetcher = ReportsFetcher()
    //let token = fetcher.fetchSearchpartyToken()!
    
    //let anisetteManager = AnisetteDataManager()
    
//    let account_data = AnisetteDataManager.shared.requestAnisetteDataAuthKit()
//    let SPT = account_data.searchPartyToken
//    
//    if let spToken = ReportsFetcher().fetchSearchpartyToken() {
//        let token = spToken
//    }
    
    let private_key_string = "0f1aac032440a25d479b749efafdcb3a570f2e8b4728c0f67ae3b83a"
    let sym_key_string = "82e3fac54317ba33110ff25907fc0e7721de189d1f83adbf9952f1945d2e266f"
    let private_key_data = private_key_string.hexadecimal
    let sym_key_data = sym_key_string.hexadecimal
    
    let myAccessory = try! Accessory(name: "Test1", key: private_key_string.hexadecimal!, symKey: sym_key_string.hexadecimal!)
    
    AnisetteDataManager.shared.requestAnisetteData { [weak Acontroller] result in
        guard let self = Acontroller else {
            print("no acessories")
            return
        }
        switch result {
        case .failure(_):
            print("no plugin")
        case .success(let accountData):
            let SPT = accountData.searchPartyToken
            
            fetcher.query(forHashes: [public_key], start: current_date as Date, duration: 1814400, searchPartyToken: SPT!) {result in
                guard let jsonData = result else {
                    return
                }
                
                do {
                    // Decode the report
                    let report = try JSONDecoder().decode(FindMyReportResults.self, from: jsonData)
                    
                    if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                        print(JSONString)
                    }
                    let reports = report.results
                    
                    if reports.count == 0 {
                        print("No reports found.")
                        return
                    }
                    
                    let key = FindMyKey(advertisedKey: try myAccessory.getAdvertisementKey(), hashedKey: Data(digest), privateKey: private_key_data!, startTime: current_date as Date, duration: 1814400, pu: nil, yCoordinate: nil, fullKey: nil)
                    
                    let locationReport = try DecryptReports.decrypt(report: reports[0], with: key)
                } catch {
                    print("Failed with error \(error)")
                }
                print("Decrypted and fetch'd")
            }
        }
    }
}

func testCertRetrieval() throws {
    
    //let myCert = CertRetreiver()
    let cert = try CertRetreiver.loadDeviceCert()
    let signCA = try CertRetreiver.secEnclaveECDSA(dataToSign: "test")
    
    
}


func test_submission() throws {
    
    let test_key = "c72c30f688c1b2a57879becf9019d8c86d26c047ec340bf07681d797"
    let data_key = test_key.hexadecimal!
    let current_date = NSDate(timeIntervalSinceNow: 0)
    
    var sha = SHA256()
    sha.update(data: data_key)
    let digest = sha.finalize()
    
    let public_key = Data(digest).base64EncodedString()
    
    let fetcher = ReportsFetcher()
    
//    let report =
//    let body = fetcher.buildQuery(public_key, start: <#T##Date#>, payload: <#T##String#>, completion: <#T##(Data?) -> Void#>)
//    let signature = try CertRetreiver.secEnclaveECDSA(dataToSign: body)
//    fetcher.submitData(test_key, httpBody: <#T##Data#>, ecdsAsign: <#T##Data#>, completion: <#T##(Data?) -> Void#>)
    
}

struct ContentView: View {
    
    internal init() {
        print("Test")

        
        do {
            
            try testKeyCreation()
            let test_accessories = [try Accessory(name: "test"), try Accessory(name: "test2"), try Accessory(name: "test3")]
            let myFindMyController = FindMyController()
            //try testCertRetrieval()
            //try test_submission()
            
            let myAccessoryController = AccessoryController(accessories: test_accessories, findMyController: myFindMyController)
            try testKeyRetreval(Acontroller: myAccessoryController)

            let myView = MainView(controller: myAccessoryController)
            let myMail = OpenHaystackPluginService()
            OpenHaystackPluginService.shared()
            
            myView.installMailPlugin()

            myView.checkPluginIsRunning(silent: false, nil)
            myView.downloadLocationReports()
            testKeyRetreval(Acontroller: myAccessoryController)
        
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
