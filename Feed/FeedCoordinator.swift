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
    var post: Post = Post(title: "Пост", author: nil, description: nil, imageName: nil, imagePic: nil, likes: nil, views: nil)

    init(navigation: UINavigationController) {
        navController = navigation

    }
    
    func start() {
        let feed = FeedViewController()
        feed.coordinator = self
        navController.pushViewController(feed, animated: true)
    }
    
    func startNavigationToRandomUrl() {
        
        let urlVm = UrlViewModel(post: post, objectToShow: nil, url: NetworkService.appConf!)
        let urlVc = UrlViewController(viewModel: urlVm)
        navController.pushViewController(urlVc, animated: true)
        
    }
    
    func startNavigationToUrl() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        let urlVm = UrlViewModel(post: post, objectToShow: "sample", url: url)
        let urlVc = UrlViewController(viewModel: urlVm)
        navController.pushViewController(urlVc, animated: true)
        
    }
    
    func startNavigationToPlanetUrl() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        let urlVm = UrlViewModel(post: post, objectToShow: "planet", url: url)
        let urlVc = UrlViewController(viewModel: urlVm)
        navController.pushViewController(urlVc, animated: true)
        
    }
    
    func startNavigationToPlayer() {
        let musicVc = MusicViewController()
        navController.pushViewController(musicVc, animated: true)
        
    }
    

}
