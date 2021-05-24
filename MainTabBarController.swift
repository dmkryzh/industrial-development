//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 21.03.2021.
//

import Foundation
import UIKit
import RealmSwift

enum AppErrors: String, Error {
    case internalError = "Some internal error"
    case unauthenticated = "User is unauthenticated"
}

class MainTabBarController: UITabBarController {
    
    let mainAlert = StartAuthorisationVC()
    
    func configureAlertActions() {
        
        let actionLogin = { [self] in
            mainAlert.signIn() {
                present(mainAlert.failureAlert, animated: true) {
                    sleep(1)
                    dismiss(animated: true) {
                        present(mainAlert.loginAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        let actionCreate = { [self] in
            mainAlert.creteAccount() {
                present(mainAlert.successAlert, animated: true) {
                    sleep(1)
                    dismiss(animated: true, completion: nil)
                }
            }
        }
        
        mainAlert.loginAlert.addAction(mainAlert.configureLoginAction(actionLogin))
        mainAlert.loginAlert.addAction(mainAlert.configureCreateAction(actionCreate))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlertActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainAlert.viewModel.statusChecker{ [self] in
            present(mainAlert.loginAlert, animated: true)
        }
    }
}

