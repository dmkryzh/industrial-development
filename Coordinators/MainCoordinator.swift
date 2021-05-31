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
    private let coreData: CoreDataStack

    init(rootViewController: UITabBarController, coreData: CoreDataStack) {
        self.rootViewController = rootViewController
        self.coreData = coreData
    }
    
    func start() {
        let feedFlow = prepareFeedFlow()
        let loginFlow = prepareLoginFlow()
        let favoriteFlow = prepareFavoriteFlow()
        
        rootViewController.viewControllers = [feedFlow, loginFlow, favoriteFlow]
        
        let feedCoordinator = FeedCoordinator(navigation: feedFlow)
        feedCoordinator.start()
        let loginCoordinator = LoginCoordinator(navigation: loginFlow, coreData: coreData)
        loginCoordinator.start()
        let favoriteCoordinator = FavoriteCoordrinator(navigation: favoriteFlow, coreData: coreData)
        favoriteCoordinator.start()
        childCoordinators = [feedCoordinator, loginCoordinator, favoriteCoordinator]
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
    
    func prepareFavoriteFlow() -> UINavigationController {
        let favoriteNav = UINavigationController()
        let favoriteItem = makeTabBarItem(image: UIImage(systemName: "heart"), title: "Favorite")
        favoriteNav.tabBarItem = favoriteItem
        return favoriteNav
        
    }
}

extension MainCoordinator {
    private func makeTabBarItem( image: UIImage? = nil, selectedImage: UIImage? = nil, title: String ) -> UITabBarItem {
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}
