//
//  Data+AES.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/26.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    
    func encrypt(key:String) -> Data? {
        return cryptCC(data: self, key: key, operation: kCCEncrypt)
    }
    
    func decrypt(key:String) -> Data? {
        return cryptCC(data: self, key: key, operation: kCCDecrypt)
    }
    
    private func cryptCC(data: Data, key: String, operation: Int) -> Data {
        
        guard key.count >= kCCKeySizeAES256 else {
            fatalError("Key size failed!")
        }
        
        let localKey = String(key.suffix(kCCKeySizeAES256))
        
        var ivBytes: [UInt8]
        var inBytes: [UInt8]
        var outLength: Int
        
        if operation == kCCEncrypt {
            ivBytes = [UInt8](repeating: 0, count: kCCBlockSizeAES128)
            guard kCCSuccess == SecRandomCopyBytes(kSecRandomDefault, ivBytes.count, &ivBytes) else {
                fatalError("IV creation failed!")
            }
            
            inBytes = Array(data)
            outLength = data.count + kCCBlockSizeAES128
            
        } else {
            ivBytes = Array(Array(data).dropLast(data.count - kCCBlockSizeAES128))
            inBytes = Array(Array(data).dropFirst(kCCBlockSizeAES128))
            outLength = inBytes.count
            
        }
        
        var outBytes = [UInt8](repeating: 0, count: outLength)
        var bytesMutated = 0
        
        guard kCCSuccess == CCCrypt(CCOperation(operation), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding), Array(localKey), kCCKeySizeAES256, &ivBytes, &inBytes, inBytes.count, &outBytes, outLength, &bytesMutated) else {
            fatalError("Cryptography operation \(operation) failed")
        }
        
        var outData = Data(bytes: &outBytes, count: bytesMutated)
        
        if operation == kCCEncrypt {
            ivBytes.append(contentsOf: Array(outData))
            outData = Data(ivBytes)
        }
        
        return outData
    }
}
