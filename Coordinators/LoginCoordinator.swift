//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.03.2021.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navController = navigation
    }
    
    func start() {
        let vc = LogInViewController()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    func startProfile() {
        let profileCoordinator = ProfileCoordinator(navigation: navController)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    
}
