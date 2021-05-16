//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Dmitrii KRY on 15.05.2021.
//

import Foundation
import Firebase

protocol LoginInspectorViewModel {
    
    func checkUser()
    func createUser(email: String, password: String)
    func signIn(email: String, password: String)
    func signOut()
    func validateLogin(_ login: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

class LoginViewModel {
    
    var loginInspector: LoginInspectorViewModel?
    
    let dispatchGroup = DispatchGroup()
    
    let dispatchQueueBacground = DispatchQueue(label: "background", qos: .background, attributes: .concurrent)
    
    func brut(indicator: UIActivityIndicatorView, completion: @escaping (String) -> Void) {
        
        var hackedValue: String?
        
        indicator.startAnimating()
        
        dispatchQueueBacground.async(group: dispatchGroup) {
            let brut = BrutForce()
            hackedValue = brut.brutForce(LoginChecker.shared.password)
            
            DispatchQueue.main.async {
                
                completion(hackedValue ?? "")
                
            }
        }
        
    }
    
    func navigateTo(login: String, password: String, trueCompletion: @escaping () -> Void, falseCompletion: @escaping () -> Void) {
        do {
            let isOK = try loginCheck(login: login, password: password)
            if isOK {
               trueCompletion()
            }
            
        } catch AppErrors.unauthenticated {
            falseCompletion()
        }
        
        catch  {
            print("unknow issue")
        }
    }
    
    func loginCheck(login: String?, password: String?) throws -> Bool {
        guard let _ = loginInspector else { throw AppErrors.internalError}
        guard loginInspector!.validateLogin(login!),
              loginInspector!.validatePassword(password!) else { throw AppErrors.unauthenticated}
        return true
    }
    
    init(loginInspector: LoginInspectorViewModel) {
        self.loginInspector = loginInspector
    }
    
    func didEnterText(login: String?, password: String?, completion: @escaping () -> Void) {
        guard login != nil, password != nil else { return }
        guard login != "", password != "" else { return }
        completion()
        
    }
}

class LoginInspectorViewModelDelegate: LoginInspectorViewModel {
    
    func checkUser() {
        //FirebaseAuth.Auth.auth().currentUser
    }
    
    func createUser(email: String, password: String) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: nil)
    }
    
    func signIn(email: String, password: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: nil)
    }
    
    func signOut() {
        try? FirebaseAuth.Auth.auth().signOut()
    }
    
    func validateLogin(_ login: String) -> Bool {
        guard login == LoginChecker.shared.login else { return false}
        return true
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard password == LoginChecker.shared.password else { return false}
        return true
    }
}

class LoginChecker {
    
    static let shared = LoginChecker()
    var login = "777"
    lazy var password: String = {
        let chars = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<4).map{ _ in chars.randomElement()! })
    }()
    private init() {}
}

