/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A struct for accessing generic password keychain items.
 */

import Foundation

private struct KeychainPasswordItem {
    // MARK: Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
    
    // MARK: Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    
    func readPassword() throws -> String  {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readPassword()
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noPassword {
            /*
             No password was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
        
        self.account = newAccountName
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainPasswordItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainPasswordItem.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        
        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }
        
        // Create a `KeychainPasswordItem` for each dictionary in the query result.
        var passwordItems = [KeychainPasswordItem]()
        for result in resultData {
            guard let account  = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }
            
            let passwordItem = KeychainPasswordItem(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        
        return passwordItems
    }
    
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}

//
//  KeyChainSecurity.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//
//  https://developer.apple.com/library/archive/samplecode/GenericKeychain/Introduction/Intro.html
//

import UIKit

class KeyChainSecurity {
    private static let serviceName = "YoChatService"
    private static let encryptionDecryptionKey = UIDevice.current.identifierForVendor?.uuidString ?? "kkhbasdlfkabsdfuishadf[pdkjbh;lsgmsmdvdfopgisdfg"
    
    private static var accounts = [(username:String, password:String)]()
    
    private static var currentAccount:(username:String, password:String)?
    
    class func hasAccounts() -> Bool {
        accounts.removeAll()
        
        do {
            let passwordItems = try KeychainPasswordItem.passwordItems(forService: serviceName)
            
            // Only one item please
            if passwordItems.count > 1 {
                for item in passwordItems {
                    try item.deleteItem()
                }
                
                return false
            }
            
            for item in passwordItems {
                let username = item.account
                let password = try item.readPassword()
                
                if let encryptedUsername = Data(base64Encoded: username), let encryptedPassword = Data(base64Encoded: password) {
                    if let itemAccountData = encryptedUsername.decrypt(key: encryptionDecryptionKey), let itemPasswordData = encryptedPassword.decrypt(key: encryptionDecryptionKey) {
                        if let usernamePlain = String(data:itemAccountData, encoding: .utf8), let passwordPlain = String(data: itemPasswordData, encoding: .utf8)  {
                            accounts.append((username:usernamePlain, password:passwordPlain))
                        } else {
                            try item.deleteItem()
                        }
                    } else {
                        try item.deleteItem()
                    }
                } else {
                    try item.deleteItem()
                }
            }
        } catch {
            return false
        }
        
        return accounts.count > 0
    }
    
    class func getAccounts() -> [(username:String, password:String)] {
        if hasAccounts() == false {
            return []
        }
        
        return accounts
    }
    
    class func setCurrentAccount(username:String, password:String) {
        self.currentAccount = .init((username: username, password: password))
    }
    
    class func saveCurrentAccount() {
        if let username = self.currentAccount?.username, let password = self.currentAccount?.password {
            KeyChainSecurity.save(username: username, password: password)
        }
    }
    
    class func save(username:String, password:String) {
        if getAccounts().count > 0 {
            deleteAll()
        }
        
        guard let usernameData = username.data(using: .utf8)?.encrypt(key: encryptionDecryptionKey), let passwordData = password
            .data(using: .utf8)?.encrypt(key: encryptionDecryptionKey) else {
            print("Can not save at this time.")
            return
        }
        
        do { try KeychainPasswordItem(service: serviceName, account: usernameData.base64EncodedString()).savePassword(passwordData.base64EncodedString()) } catch let error {
            print(error)
        }
    }
    
    class func delete(username:String) {
        do { try KeychainPasswordItem(service: serviceName, account: username).deleteItem() } catch {}
    }
    
    class func deleteAll() {
        do {
            let passwordItems = try KeychainPasswordItem.passwordItems(forService: serviceName)
    
            for item in passwordItems {
                try item.deleteItem()
            }
        } catch {}
    }
}
