//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 22.03.2021.
//

import Foundation
import UIKit

class FeedCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController

    init(navigation: UINavigationController) {
        navController = navigation

    }
    
    func start() {
        let feed = FeedViewController()
        feed.coordinator = self
        navController.pushViewController(feed, animated: true)
    }

}
