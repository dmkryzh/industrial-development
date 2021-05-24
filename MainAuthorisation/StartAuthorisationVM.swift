//
//  StartAuthorisationVM.swift
//  Navigation
//
//  Created by Dmitrii KRY on 24.05.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class StartAuthorisationVM {
    
    let realm = try! Realm()
    
    func statusChecker(_ alert: (()->Void)?) {
        
        guard realm.objects(Status.self).count == 0 else { return }
        alert!()
    }
}

extension StartAuthorisationVM: LoginInspectorViewModel {

    func createUser(email: String, password: String, completion: (() -> Void)?) {
        
        try? realm.write {
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
