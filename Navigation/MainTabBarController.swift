//
//  MainTabBarController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 21.03.2021.
//

import Foundation
import UIKit


class MainTabBarController: UITabBarController {

    let feed = FeedCoordinator()
    let profile = ProfileCoordinator()
    let login = LoginCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [feed.navController!, login.navController!]

    }

}

