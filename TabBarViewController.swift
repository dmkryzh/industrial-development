//
//  TabBarViewController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 11.03.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let feed = FeedViewController()
        let feedNav = UINavigationController(rootViewController: feed)
      
        
        tabBar.tintColor = UIColor.black

        let itemFeed: UITabBarItem = {
            let itemFeed = UITabBarItem()
            itemFeed.title = "Feed"
            itemFeed.image = UIImage(named: "house")
            itemFeed.tag = 0
            return itemFeed
        }()
        
        feedNav.tabBarItem = itemFeed
                
        let profile = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profile)
        
        let itemProfile: UITabBarItem = {
            let itemProfile = UITabBarItem()
            itemProfile.title = "Profile"
            itemProfile.image = UIImage(named: "person" )
            itemProfile.tag = 1
            return itemProfile
        }()

        profileNav.tabBarItem = itemProfile
        
        viewControllers = [feedNav, profileNav]
   
    }


}

// Коммент для pr. Все таски выполнены
