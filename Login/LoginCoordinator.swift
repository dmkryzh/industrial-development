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
    private let coreData: CoreDataStack
    
    init(navigation: UINavigationController, coreData: CoreDataStack) {
        self.navController = navigation
        self.coreData = coreData
    }
    
    func start() {
        let vm = LoginViewModel()
        let vc = LogInViewController(vm)
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }
    
    func startProfile() {
        let profileCoordinator = ProfileCoordinator(navigation: navController, coreData: coreData)
        childCoordinators.append(profileCoordinator)
        profileCoordinator.start()
    }
    
    
}
