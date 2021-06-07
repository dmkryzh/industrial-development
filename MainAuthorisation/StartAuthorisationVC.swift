//
//  StartAuthorisationVC.swift
//  Navigation
//
//  Created by Dmitrii KRY on 24.05.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

class StartAuthorisationVC {
    
    let viewModel = StartAuthorisationVM()
    
    lazy var successAlert = UIAlertController(title: "Success", message: "Account for \"\(loginAlert.textFields?[0].text ?? "")\" is created", preferredStyle: .alert)
    
    var failureAlert = UIAlertController(title: "Failure", message: "Either login or passworg is wrong, please try again", preferredStyle: .alert)

    
    func configureLoginAction(_ action: (() -> Void)?) -> UIAlertAction {
        
        let action = UIAlertAction(title: "Sign in", style: .default) { _ in
            guard let action = action else { return }
            action()
        }
        return action
    }
    
    func configureCreateAction(_ action: (() -> Void)?) -> UIAlertAction {
        
        let action = UIAlertAction(title: "Sign up", style: .default) { _ in
            guard let _ = action else { return }
            action!()
        }
        return action
    }
    
    lazy var loginAlert: UIAlertController = {
        
        let alertCont = UIAlertController(title: "Authentication", message: "Please fill login and password fields for authentication", preferredStyle: .alert)
        
        alertCont.addTextField() { login in
            login.textColor = .black
            login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            login.autocapitalizationType = .none
            login.tintColor = UIColor.init(named: "accentColor")
            login.autocapitalizationType = .none
            login.placeholder = "Login"
            login.textContentType = .password
            login.isSecureTextEntry = true
        }
        
        alertCont.addTextField() { login in
            login.textColor = .black
            login.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            login.autocapitalizationType = .none
            login.tintColor = UIColor.init(named: "accentColor")
            login.autocapitalizationType = .none
            login.placeholder = "Password"
            login.textContentType = .password
            login.isSecureTextEntry = true
        }
        return alertCont
    }()
    
    func signIn(_ alertCompletion: (() -> Void)? = nil) {
        guard let login = loginAlert.textFields?[0].text else { return }
        guard let password = loginAlert.textFields?[1].text else { return }
        guard let alert = alertCompletion else { return }
        viewModel.signIn(email: login, password: password, signInCompletion: nil, alertCompletion: alert)
    }
    
    func creteAccount(_ alertCompletion: (() -> Void)? = nil) {
        guard let login = loginAlert.textFields?[0].text else { return }
        guard let password = loginAlert.textFields?[1].text else { return }
        guard let alert = alertCompletion else { return }
        viewModel.createUser(email: login, password: password, completion: alert)
    }
    
}
