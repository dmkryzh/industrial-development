//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 22.03.2021.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: LoginCoordinator?
    var navController: UINavigationController

    init(navigation: UINavigationController) {
        navController = navigation
    }
    
    func start() {
        let vc = ProfileViewController()
        vc.coordinator = self
        navController.setViewControllers([vc], animated: true)
    }

}
