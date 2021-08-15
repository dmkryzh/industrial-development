//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Dmitrii KRY on 14.08.2021.

import Foundation
import LocalAuthentication
import UIKit

class LocalAuthorizationService {
    
    let context = LAContext()
    let reason = "To access user data"
    var authError: NSError?
    
    func authorizeIfPossible(_ isAuthorizationFinished: @escaping (Bool) -> Void) {
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.localizedCancelTitle = "Отмена"
            context.localizedFallbackTitle = ""
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        isAuthorizationFinished(true)
                    } else {
                        isAuthorizationFinished(false)
                        print(evaluateError?.localizedDescription as Any)
                    }
                }
            }
        } else {
            print("Sorry, can't evaluate policy. \(String(describing: authError?.localizedDescription))")
        }
    }
}
