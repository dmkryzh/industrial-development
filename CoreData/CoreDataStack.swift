//
//  CoreDataStack.swift
//  Navigation
//
//  Created by Dmitrii KRY on 29.05.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func fetchTasks(_ predicate: NSPredicate? = nil) -> [PostStorage] {
        let request: NSFetchRequest<PostStorage> = PostStorage.fetchRequest()
        if let predicate = predicate {
        request.predicate = predicate
        }
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("🤷‍♂️ Что-то пошло не так..")
        }
    }
    
    func remove(task: PostStorage) {
        viewContext.delete(task)
        saveContext(context: viewContext)
    }
    
    func removeAll() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PostStorage")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: viewContext)
        } catch {
            fatalError("🤷‍♂️ Что-то пошло не так..")
        }
    }
    
    func createNewTask(content: Post) {
        backgroundContext.perform { [self] in
            let newTask = PostStorage(context: viewContext)
            newTask.image = content.imageName ?? ""
            newTask.likes = content.likes ?? ""
            newTask.postDescription = content.description ?? ""
            newTask.title = content.title ?? ""
            newTask.views = content.views ?? ""
            newTask.author = content.author ?? ""
            saveContext(context: viewContext)
        }
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
        }
    }
    
    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: viewContext)
    }
    
}

