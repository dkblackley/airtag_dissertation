//
//  AuthenticationManager.swift
//  AirFrag
//
//  Created by Daniel on 27/06/2022.
//

import Foundation
import OSLog
import CryptoKit

public class AuthenticationManager: NSObject {
    @objc static let shared = AuthenticationManager()

    func requestAuthData(_ completion: @escaping (Result<AuthenticationData, Error>) -> Void) {
        
    }
    
    @objc func requestHeaderObjC(_ completion: @escaping ([AnyHashable: Any]?) -> Void) {
        
        do {
            let deviceCA = try CertRetreiver.loadDeviceCert()
            let cA = SecCertificateCopyNormalizedIssuerSequence(deviceCA)
            let base64Device = (deviceCA as! Data).base64EncodedString()
            
            var sha = SHA256()
            sha.update(data: deviceCA as! Data)
            let digest = sha.finalize()
            let cAhash = Data(digest).base64EncodedString()
            let date = Date()
            let Timezone = TimeZone.current
            
            let headers = AuthenticationData(deviceCA: base64Device, cAhash: cAhash, date: date, timeZone: Timezone)
            completion([
                    "X-Apple-Sign1": headers?.deviceCA,
                    "X-Apple-Sign2": headers?.cAhash,
                //  "X-Apple-Sign3": data.ecdsAsig,
                    "X-Apple-I-TimeZone": String(headers?.timeZone.abbreviation() ?? "UTC"),
                    "X-Apple-I-Client-Time": ISO8601DateFormatter().string(from: (headers?.date)!),
                    ] as [AnyHashable: Any])
        }
        catch {
            print(error)
        }
        
        return
        
        
//        self.requestSignData { result in
//            switch result {
//            case .failure:
//                completion(nil)
//            case .success(let data):
//                // Return only the headers
//                completion(
//                    [
//                        "X-Apple-Sign1": data.deviceCA,
//                        "X-Apple-Sign2": data.cAhash,
////                        "X-Apple-Sign3": data.ecdsAsig,
//                        "X-Apple-I-TimeZone": String(data.timeZone.abbreviation() ?? "UTC"),
//                        "X-Apple-I-Client-Time": ISO8601DateFormatter().string(from: data.date),
//                    ] as [AnyHashable: Any])
//            }
//        }
    }


    func requestDate() -> Date? {
        let anisetteData = ReportsFetcher().anisetteDataDictionary()

        let dateFormatter = ISO8601DateFormatter()

        guard
            let dateString = anisetteData["X-Apple-I-Client-Time"] as? String,
            let date = dateFormatter.date(from: dateString)
        else {
            return nil
        }

        return date
    }
//
//    @objc func requestAnisetteDataObjc(_ completion: @escaping ([AnyHashable: Any]?) -> Void) {
//        self.requestAnisetteData { result in
//            switch result {
//            case .failure:
//                completion(nil)
//            case .success(let data):
//                // Return only the headers
//                completion(
//                    [
//                        "X-Apple-I-MD-M": data.machineID,
//                        "X-Apple-I-MD": data.oneTimePassword,
//                        "X-Apple-I-TimeZone": String(data.timeZone.abbreviation() ?? "UTC"),
//                        "X-Apple-I-Client-Time": ISO8601DateFormatter().string(from: data.date),
//                        "X-Apple-I-MD-RINFO": String(data.routingInfo),
//                    ] as [AnyHashable: Any])
//            }
//        }
//    }
}

//extension AnisetteDataManager {
//
//    @objc fileprivate func handleAppleDataResponse(_ notification: Notification) {
//        guard let userInfo = notification.userInfo, let requestUUID = userInfo["requestUUID"] as? String else { return }
//
//        if let archivedAnisetteData = userInfo["authData"] as? Data,
//            let appleAccountData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: AppleAccountData.self, from: archivedAnisetteData)
//        {
//            if let range = appleAccountData.deviceDescription.lowercased().range(of: "(com.apple.mail") {
//                var adjustedDescription = appleAccountData.deviceDescription[..<range.lowerBound]
//                adjustedDescription += "(com.apple.dt.Xcode/3594.4.19)>"
//
//                appleAccountData.deviceDescription = String(adjustedDescription)
//            }
//
//            self.finishRequest(forUUID: requestUUID, result: .success(appleAccountData))
//        } else {
//            self.finishRequest(forUUID: requestUUID, result: .failure(AnisetteDataError.invalidAnisetteData))
//        }
//    }
//
//    @objc fileprivate func handleAnisetteDataResponse(_ notification: Notification) {
//        guard let userInfo = notification.userInfo, let requestUUID = userInfo["requestUUID"] as? String else { return }
//
//        if let archivedAnisetteData = userInfo["anisetteData"] as? Data,
//            let anisetteData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ALTAnisetteData.self, from: archivedAnisetteData)
//        {
//            if let range = anisetteData.deviceDescription.lowercased().range(of: "(com.apple.mail") {
//                var adjustedDescription = anisetteData.deviceDescription[..<range.lowerBound]
//                adjustedDescription += "(com.apple.dt.Xcode/3594.4.19)>"
//
//                anisetteData.deviceDescription = String(adjustedDescription)
//            }
//
//            let appleAccountData = AppleAccountData(fromALTAnissetteData: anisetteData)
//            self.finishRequest(forUUID: requestUUID, result: .success(appleAccountData))
//        } else {
//            self.finishRequest(forUUID: requestUUID, result: .failure(AnisetteDataError.invalidAnisetteData))
//        }
//    }
//
//    fileprivate func finishRequest(forUUID requestUUID: String, result: Result<AppleAccountData, Error>) {
//        let completionHandler = self.anisetteDataCompletionHandlers[requestUUID]
//        self.anisetteDataCompletionHandlers[requestUUID] = nil
//
//        let timer = self.anisetteDataTimers[requestUUID]
//        self.anisetteDataTimers[requestUUID] = nil
//
//        timer?.invalidate()
//        completionHandler?(result)
//    }
//}

enum AuthenticationDataError: Error {
    case invalidAnisetteData
}
