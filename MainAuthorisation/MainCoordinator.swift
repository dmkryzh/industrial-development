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
        let mapsFlow = prepareMapsFlow()
        
        rootViewController.viewControllers = [feedFlow, loginFlow, favoriteFlow, mapsFlow]
        
        let feedCoordinator = FeedCoordinator(navigation: feedFlow)
        feedCoordinator.start()
        let loginCoordinator = LoginCoordinator(navigation: loginFlow, coreData: coreData)
        loginCoordinator.start()
        let favoriteCoordinator = FavoriteCoordrinator(navigation: favoriteFlow, coreData: coreData)
        favoriteCoordinator.start()
        let mapsCoordinator = MapsCoordinator(navigation: mapsFlow)
        mapsCoordinator.start()
        childCoordinators = [feedCoordinator, loginCoordinator, favoriteCoordinator, mapsCoordinator]
    }
    
    func prepareFeedFlow() -> UINavigationController {
        let feedNav = UINavigationController()
        let feedBarItem = makeTabBarItem( image: UIImage(named: "house"), title: StringsForLocale.tabFeed.localaized )
        feedNav.tabBarItem = feedBarItem
        return feedNav
    }
    
    func prepareLoginFlow() -> UINavigationController {
        let loginNav = UINavigationController()
        let loginBarItem = makeTabBarItem(image: UIImage(named: "person"), title: StringsForLocale.tabProfile.localaized)
        loginNav.tabBarItem = loginBarItem
        return loginNav
        
    }
    
    func prepareFavoriteFlow() -> UINavigationController {
        let favoriteNav = UINavigationController()
        let favoriteItem = makeTabBarItem(image: UIImage(systemName: "heart"), title: StringsForLocale.tabFavorite.localaized)
        favoriteNav.tabBarItem = favoriteItem
        return favoriteNav
        
    }
    
    func prepareMapsFlow() -> UINavigationController {
        let mapsNav = UINavigationController()
        let mapsItem = makeTabBarItem(image: UIImage(systemName: "map"), title: StringsForLocale.maps.localaized)
        mapsNav.tabBarItem = mapsItem
        return mapsNav
        
    }
}

extension MainCoordinator {
    private func makeTabBarItem( image: UIImage? = nil, selectedImage: UIImage? = nil, title: String ) -> UITabBarItem {
        return UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}
