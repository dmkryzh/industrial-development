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

class LocalNotificationsService: NSObject {
    
    lazy var center: UNUserNotificationCenter = {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return center
    }()

    func registerForPushNotifications() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            DispatchQueue.main.async {
                self?.registerCategories()
                self?.scheduleNotification()
            }
        }
    }
    
    func registerCategories() {

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: [.foreground])
        let category = UNNotificationCategory(identifier: "updates", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func scheduleNotification() {

        let content = UNMutableNotificationContent()
        content.title = "Внимание"
        content.body = "Посмотрите последние обновленя"
        content.categoryIdentifier = "updates"
        content.userInfo = ["customData": "qwe"]
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = 23
        dateComponents.minute = 31
        
        _ = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        
        let triggerScheduled = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: triggerScheduled)
        
        center.add(request) { error in
            if let error = error {
            print(error)
            } else {
            print("Notification scheduled! ID = \(request.identifier)")
            }
        }
    }
}

extension LocalNotificationsService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.actionIdentifier
        print("Received notification with ID = \(id)")
        
        switch response.actionIdentifier {
        case "show":
            print("some action")
            completionHandler()
        default:
            break
        }
    }
}
