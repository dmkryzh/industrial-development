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
    
    var predicate: String? {
        didSet {
            fetchPosts()
        }
    }

    func fetchPosts() {
        guard let predicate = self.predicate else {
            self.savePosts = coreData.fetchTasks()
            return
        }
        let nsPredicate = NSPredicate(format: "%K == %@", #keyPath(PostStorage.author), predicate)
        self.savePosts = coreData.fetchTasks(nsPredicate)
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
    
    func search(_ element: String) {
        
    }
    
    init(cd: CoreDataStack) {
        coreData = cd
    }
    
}
