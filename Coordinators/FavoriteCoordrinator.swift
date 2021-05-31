//
//  c.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.05.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCoordrinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navController: UINavigationController
    private let coreData: CoreDataStack
    
    init(navigation: UINavigationController, coreData: CoreDataStack) {
        navController = navigation
        self.coreData = coreData
    }
    
    func start() {
        let favVM = FavoriteVM(cd: coreData)
        let favVC = FavoriteViewController(vm: favVM)
        navController.pushViewController(favVC, animated: true)
    }
    
    func startPhotos() {
        let photosVm = PhotosViewModel(numberOfSections: 1, collectionIdentifier: "PhotosCell", photoSet: PhotoSet.photoSet)
        let photosVc = PhotosViewController(viewModel: photosVm)
        photosVc.coordinator = self
        navController.pushViewController(photosVc, animated: true)
    }

}
