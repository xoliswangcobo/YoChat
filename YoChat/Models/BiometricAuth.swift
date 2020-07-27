//
//  BiometricAuth.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/26.
//  Copyright © 2020 Xoliswa. All rights reserved.
//
//  https://www.raywenderlich.com/236-how-to-secure-ios-user-data-the-keychain-and-biometrics-face-id-or-touch-id
//

import Foundation
import LocalAuthentication

class BiometricAuth {
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    private static let context = LAContext()
    
    class func isSupported() -> Bool {
        return BiometricAuth.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    class func biometricType() -> BiometricType {
        let _ = BiometricAuth.isSupported()
        
        switch BiometricAuth.context.biometryType {
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            default:
                return .none
        }
    }
    
    class func authenticate(completion: @escaping (Error?, Bool) -> Void) {
        guard BiometricAuth.isSupported() else {
            DispatchQueue.main.async {
                completion(NSError(domain: "BIOMETRIC_AUTH", code: 201001, userInfo: [ NSLocalizedDescriptionKey : "Biometric ID authentication failed" ]), false)
            }
            
            return
        }
        
        BiometricAuth.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Fingerprint authentication") { success, evaluateError in
            DispatchQueue.main.async {
                completion(evaluateError, success)
            }
        }
    }
}
