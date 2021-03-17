//
//  AppDelegate.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = TabBarViewController()
        window!.makeKeyAndVisible()
        print(type(of: self), #function)
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        print(type(of: self), #function)
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(type(of: self), #function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(type(of: self), #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print(type(of: self), #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(type(of: self), #function)
        // функция выполнялась в фоне 26 секунд, в FeedViewController есть код
    }
    
    
}

