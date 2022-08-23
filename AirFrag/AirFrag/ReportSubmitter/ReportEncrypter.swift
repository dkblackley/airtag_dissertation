//
//  OpenHaystack – Tracking personal Bluetooth devices via Apple's Find My network
//
//  Copyright © 2021 Secure Mobile Networking Lab (SEEMOO)
//  Copyright © 2021 The Open Wireless Link Project
//
//  SPDX-License-Identifier: AGPL-3.0-only
//

import CryptoKit
import Foundation
import SwiftECC


struct EncryptReports {
    
    /// Takes an unencrypted report and encrypts it
    ///
    /// - Parameters:
    ///   - report: A FindMy Report
    ///   - key: A FindMyKey to encrypt the payload
    /// - Throws: Errors if the encryption fails
    /// - Returns: An encrypted location report
    static func encrypt(report: FindMyLocationReport, with pubKey: Foundation.Data) throws -> Data {
        
        let payloadData = self.encode(content: report)
        let privkey = BoringSSL.generateNewPrivateKey()!
        
        let eph_key = BoringSSL.deriveUncompressedPublicKey(fromPrivateKey: privkey)!
        let advert_key = BoringSSL.uncompressPublicKey(pubKey)
        
        guard let sharedKey = BoringSSL.deriveSharedKey(fromPrivateKey: privkey, andEphemeralKey: advert_key!) else {
            throw FindMyError.decryptionError(description: "Failed generating shared key")
        }
        
        let key = kdf(fromSharedSecret: sharedKey, andEphemeralKey: eph_key)
        
        print("Derived key \(key.base64EncodedString())")
        print("eph key \(eph_key.base64EncodedString())")
        print("Shared key \(sharedKey.base64EncodedString())")
        
        let nonce = key.subdata(in: 16..<key.endIndex)
        let encrypt_key = key.subdata(in: 0..<16)
        
        let enc_payload = try encryptPayload(plaintext: payloadData, symmetricKey: encrypt_key, nonce: nonce)
        //var eph_pub_key = eph_key
        

        
//        var timestamp = Foundation.Date().timeIntervalSinceReferenceDate
//        var location_report = Data(toByteArray(timestamp)[0...3])
//        let confidence = toByteArray(6)[0]
        
        
        var timestamp = report.timestamp?.timeIntervalSinceReferenceDate
        let confidence = toByteArray(report.confidence)[0]
        
        var location_report = Data(toByteArray(timestamp)[0...3])
        location_report.append(confidence)
        location_report.append(eph_key)
        location_report.append(enc_payload)
        
        return location_report
    }
    
    /// Decrypt the payload.
    ///
    /// - Parameters:
    ///   - payload: Encrypted payload part
    ///   - symmetricKey: Symmetric key
    ///   - tag: AES GCM tag
    /// - Throws: AES GCM error
    /// - Returns: Decrypted error
    static func encryptPayload(plaintext: Data, symmetricKey: Data, nonce: Data) throws -> Data {
        
        print("Decryption Key: \(symmetricKey.base64EncodedString())")
        print("IV: \(nonce.base64EncodedString())")
        
        let symKey = SymmetricKey(data: symmetricKey)
        
//        var random_data = Data(count: 16)
//        let result = random_data.withUnsafeMutableBytes {
//            SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!)
//        }
        
        //let random_data = "5477bcd2bebda899aaa526c61faea5c6".hexadecimal
        
        //print(random_data!.hexEncodedString())
        
        let sealedBox = try AES.GCM.seal(plaintext, using: symKey, nonce: AES.GCM.Nonce(data: nonce))
        
        var ciphertext = Data(sealedBox.ciphertext)
        let tag = Data(sealedBox.tag)
        
        ciphertext.append(tag)
        
        print("Tag: \(tag.base64EncodedString())")
        
        return ciphertext
    }
    
    static func encode(content: FindMyLocationReport) -> Data {
        
        var report = Data()
        report.append(contentsOf: toByteArray(content.latitude)[0...3])
        report.append(contentsOf: toByteArray(content.longitude)[0...3])
        report.append(contentsOf: [content.accuracy])
        report.append(contentsOf: [16 as UInt8]) //Just a random status
        
        return report
        
    }
    
    static func kdf(fromSharedSecret secret: Data, andEphemeralKey ephKey: Data) -> Data {
        
        var shaDigest = SHA256()
        shaDigest.update(data: secret)
        var counter: Int32 = 1
        let counterData = Data(Data(bytes: &counter, count: MemoryLayout.size(ofValue: counter)).reversed())
        shaDigest.update(data: counterData)
        shaDigest.update(data: ephKey)
        
        let derivedKey = shaDigest.finalize()
        
        return Data(derivedKey)
    }
    
    static func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafeBytes(of: &value) { Array($0) }
    }
}
