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
    
    private let coreData: CoreDataStack
    
    var reloadOutput: FavoriteVmOutput?
    
    var savePosts: [PostStorage]?
    
    func fetchPosts() {
        savePosts = coreData.fetchTasks()
    }
    
    func removeAll() {
        coreData.removeAll { [self] in
            fetchPosts()
            reloadOutput?.reloadData()
        }
    }
    
    func deletePost(_ task: PostStorage) {
        coreData.remove(task: task) { [self] in
            fetchPosts()
            reloadOutput?.reloadData()
        }
    }
    
    init(cd: CoreDataStack) {
        coreData = cd
    }
    
}
