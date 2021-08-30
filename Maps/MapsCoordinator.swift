//
//  MapsCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 29.08.2021.
//

import Foundation
import UIKit

class MapsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navController = navigation
    }
    
    func start() {
        let vc = MapsViewController()
        vc.coordinator = self
        navController.pushViewController(vc, animated: true)
    }

}
