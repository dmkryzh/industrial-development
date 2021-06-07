//
//  StartAuthorisationVM.swift
//  Navigation
//
//  Created by Dmitrii KRY on 24.05.2021.

import Foundation
import UIKit
import RealmSwift

class StartAuthorisationVM {
    
    func getKey() -> Data {
        let keychainIdentifier = "NavigationAuthorisationKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
    
    lazy var config = Realm.Configuration(encryptionKey: getKey())
    
    lazy var realm: Realm = {
        do {
            return try Realm(configuration: config)
        } catch {
            try! FileManager().removeItem(at: config.fileURL!)
            return try! Realm(configuration: config)
        }
    }()
    
    func statusChecker(_ alert: (()->Void)?) {
        guard realm.objects(Status.self).count == 0 else { return }
        alert!()
    }
    
}

extension StartAuthorisationVM: LoginInspectorViewModelDelegate {
    
    func createUser(email: String, password: String, completion: (() -> Void)?) {
        
        try? realm .write {
            let newAccount = Account.create(login: email, password: password)
            realm.add(newAccount)
            let status = Status.create(true)
            realm.add(status)
        }
        guard let _ = completion else { return }
        completion!()
    }
    
    func signIn(email: String, password: String, signInCompletion: (() -> Void)?, alertCompletion: (() -> Void)?) {
        let login = realm.objects(Account.self).filter("login = '\(email)' AND password = '\(password)'")
        
        if login.isEmpty {
            guard let _ = alertCompletion else { return }
            alertCompletion!()
        } else {
            guard let _ = signInCompletion else { return }
            signInCompletion!()
            
            try? realm.write {
                
            }
            
        }
    }
}
