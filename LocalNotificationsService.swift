//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Dmitrii KRY on 21.08.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotificationsService {
    
    let center = UNUserNotificationCenter.current()
    
    func registerForPushNotifications() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                self?.scheduleNotification()
            }
        }
    }
    
    func scheduleNotification() {

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 31
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
            print(error)
            } else {
            print("Notification scheduled! ID = \(request.identifier)")
            }
        }
    }
    
    func registerCategories() {
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    
    func registeForLatestUpdatesIfPossible() {
        
    }
    
}
