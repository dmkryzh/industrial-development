//
//  FavoriteVM.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.05.2021.
//

import Foundation

protocol FavoriteVmOutput {
    func reloadData()
}

class FavoriteVM {
    
    var coreData: CoreDataStack
    
    var reload: FavoriteVmOutput?
    
    var savePosts: [PostStorage]?
    
    func fetchPosts() {
        savePosts = coreData.fetchTasks()
    }
    
    func removeAll() {
        coreData.removeAll()
    }
    
    func deletePost(_ task: PostStorage) {
        coreData.remove(task: task)
    }
    
    init(cd: CoreDataStack) {
        coreData = cd
        coreData.clousure = { [self] in
            fetchPosts()
            reload?.reloadData()
        }
    }
    
}
