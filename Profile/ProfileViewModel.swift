//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Dmitrii KRY on 23.03.2021.
//

import Foundation
import UIKit



class ProfileViewModel {
    
    private let coreData: CoreDataStack
    
    func saveLikedPost(_ post: Post) {
        coreData.createNewTask(content: post)
    }
    
    func loadLikedPost() -> [PostStorage] {
        let posts = coreData.fetchTasks()
        return posts
    }
    
    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
    
}
