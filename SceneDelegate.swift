//
//  SceneDelegate.swift
//  Navigation
//

import UIKit
import Firebase
import RealmSwift
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let coreDataStack = CoreDataStack()
    
        // MARK: - Core Data Saving support
        
        func saveContext () {
            let context = coreDataStack.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    var window: UIWindow?
    var appCoordinator: MainCoordinator?
    let urls = ["https://swapi.dev/api/people/8",
                "https://swapi.dev/api/starships/3",
                "https://swapi.dev/api/planets/5"]
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let startController = MainTabBarController()
        appCoordinator = MainCoordinator(rootViewController: startController, coreData: coreDataStack)
        window?.rootViewController = appCoordinator?.rootViewController
        let appConfiguration = AppConfiguration.optionTwo(URL(string: urls.randomElement()!)!)
        NetworkService.appConf = appConfiguration.returnUrl()
        FirebaseApp.configure()
        window?.makeKeyAndVisible()
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

