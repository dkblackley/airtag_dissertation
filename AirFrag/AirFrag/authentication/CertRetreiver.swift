//
//  KeychainController.swift
//  AirFrag
//
//  Created by Daniel on 28/06/2022.
//

import Foundation
import OSLog
import Security
import CryptoKit

struct CertRetreiver {
    
    enum CertRetreiverError: Error {
        case certNotFound
        case noEnclave
    }
    
    static func loadDeviceCert() throws -> SecCertificate {
        var query: [String: Any] = [
            kSecClass as String: kSecClassCertificate,
            //kSecAttrLabel as String: "com.apple.systemdefault",
            kSecAttrDescription as String: "Apple System Identity",
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnRef as String: kCFBooleanTrue,
        ]
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw CertRetreiverError.certNotFound
        }

        // Convert from Object to Cert
        let cert = result as! SecCertificate
        return cert
    }
    
    static func secEnclaveECDSA(dataToSign: String) throws -> String {
        
        guard SecureEnclave.isAvailable else { throw CertRetreiverError.noEnclave }
        
        let signingKey = try! SecureEnclave.P256.Signing.PrivateKey()
        print("Signing key data: \(signingKey.dataRepresentation.base64EncodedString())")
        
        let access =
        SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                        .privateKeyUsage,
                                        nil)
        
        return ""
    }
}
