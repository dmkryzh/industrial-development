//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Dmitrii KRY on 22.03.2021.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator  {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UITabBarController

    init(rootViewController: UITabBarController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let feedFlow = prepareFeedFlow()
        let loginFlow = prepareLoginFlow()
        
        rootViewController.viewControllers = [feedFlow, loginFlow]
        
        let feedCoordinator = FeedCoordinator(navigation: feedFlow)
        feedCoordinator.start()
        let loginCoordinator = LoginCoordinator(navigation: loginFlow)
        loginCoordinator.start()
        childCoordinators = [feedCoordinator, loginCoordinator]
    }
    
    func prepareFeedFlow() -> UINavigationController {
        let feedNav = UINavigationController()
        let feedBarItem = makeTabBarItem( image: UIImage(named: "house"), title: "Feed" )
        feedNav.tabBarItem = feedBarItem
        return feedNav
    }
    
    func prepareLoginFlow() -> UINavigationController {
        let loginNav = UINavigationController()
        let loginBarItem = makeTabBarItem(image: UIImage(named: "person"), title: "Profile")
        loginNav.tabBarItem = loginBarItem
        return loginNav
        
    }
}

extension MainCoordinator {
    private func makeTabBarItem( image: UIImage? = nil, selectedImage: UIImage? = nil, title: String ) -> UITabBarItem {
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}
