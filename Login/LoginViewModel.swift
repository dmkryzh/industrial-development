//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Dmitrii KRY on 15.05.2021.
//

import Foundation
import Firebase
import FirebaseAuth

protocol LoginInspectorViewModel {

    func createUser(email: String, password: String, completion: (() -> Void)?)
    func signIn(email: String, password: String, signInCompletion: (() -> Void)?, alertCompletion: (() -> Void)?)
    func showLoginAlert(email: String, password: String, alertHandler: ((UIAlertController) -> Void)?, successHandler: (() -> Void)?, failureHandler: (()->Void)?)
    func validateLogin(_ login: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

extension LoginInspectorViewModel {
    func showLoginAlert(email: String, password: String, alertHandler: ((UIAlertController) -> Void)?, successHandler: (() -> Void)?, failureHandler: (()->Void)?) {
    }
    
    func validateLogin(_ login: String) -> Bool {
        return false
    }
    
    func validatePassword(_ password: String) -> Bool {
        return false
    }
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
    
    func navigateTo(login: String?, password: String?, trueCompletion: @escaping () -> Void, falseCompletion: @escaping () -> Void) {
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
    
    func didEnterText(login: String?, password: String?, trueCompletion: @escaping () -> Void, falseCompletion: @escaping () -> Void) {
        guard login != nil, password != nil else {
            falseCompletion()
            return }
        guard login != "", password != "" else {
            falseCompletion()
            return
        }
        trueCompletion()
        
    }
}


class LoginInspectorViewModelDelegate: LoginInspectorViewModel {
    
    func showLoginAlert(email: String, password: String, alertHandler: ((UIAlertController) -> Void)?, successHandler: (()->Void)?, failureHandler: (()->Void)?) {
        
        let loginAlert: UIAlertController = {
            
            let alert = UIAlertController(title: "Login error", message: "Acccount with provided credentionals doesn't exist, do you want to crete a new one?", preferredStyle: .alert)
            
            let createPassword = UIAlertAction(title: "Create account", style: .default) { [self] _ in
                createUser(email: email, password: password, completion: successHandler)
            }
            
            let tryAgain = UIAlertAction(title: "Try again", style: .default)
            alert.addAction(createPassword)
            alert.addAction(tryAgain)
            
            return alert
        }()
        
        alertHandler!(loginAlert)
    }

    func createUser(email: String, password: String, completion: (() -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let error = error else {
                guard let _ = completion else { return }
                completion!()
                print(result!)
                return
            }
            print(error.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String, signInCompletion: (() -> Void)?, alertCompletion: (() -> Void)? ) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let error = error else {
                guard let _ = signInCompletion else { return }
                signInCompletion!()
                print(result!)
                return
            }
            print(error)
            alertCompletion!()
        }
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

