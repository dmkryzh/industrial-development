//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.03.2021.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    var viewController: UIViewController
    
    var navController: UINavigationController?
    
    init() {
        viewController = LogInViewController()
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 1)
        navController = UINavigationController(rootViewController: viewController)
    }
    
    func start() {
    }
    
    
}
