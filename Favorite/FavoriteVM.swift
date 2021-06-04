//
//  FavoriteVM.swift
//  Navigation
//
//  Created by Dmitrii KRY on 26.05.2021.
//

import Foundation
import CoreData

protocol FavoriteVmOutput {
    func reloadData()
}

class FavoriteVM {
    
    lazy var fetchResultsController: NSFetchedResultsController<PostStorage> = {
        let request: NSFetchRequest<PostStorage> = PostStorage.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: false)]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return controller
    }()
    
    private let coreData: CoreDataStack
    
    var context: NSManagedObjectContext {
        coreData.viewContext
    }
    
    var reloadOutput: FavoriteVmOutput?
    
    var author: String? {
        didSet {
            fetchPosts()
        }
    }
    
    func fetchPosts() {
        guard let author = author else {
            fetchResultsController.fetchRequest.predicate = nil
            try? fetchResultsController.performFetch()
            reloadOutput?.reloadData()
            return
        }
        let nsPredicate = NSPredicate(format: "%K == %@", #keyPath(PostStorage.author), author)
        fetchResultsController.fetchRequest.predicate = nsPredicate
        try? fetchResultsController.performFetch()
        reloadOutput?.reloadData()
    }
    
    func removeAll() {
        coreData.removeAll()
    }
    
    func deletePost(_ task: PostStorage) {
        coreData.remove(task: task)
    }
    
    init(cd: CoreDataStack) {
        coreData = cd
    }
    
}
