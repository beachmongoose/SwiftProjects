//
//  ViewController.swift
//  Project21
//
//  Created by Maggie Maldjian on 8/10/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleDefault))
    
  }

  @objc func registerLocal() {
    
    let center = UNUserNotificationCenter.current()
    
    center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        print("Yay!")
      } else {
        print ("No")
      }
    }
  }
  
  func registerCategories() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    let snooze = UNNotificationAction(identifier: "snooze", title: "Remind me later.", options: .foreground)
    let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
    let category = UNNotificationCategory(identifier: "alarm", actions: [show, snooze], intentIdentifiers: [])
  
    center.setNotificationCategories([category])
  }
  
  @objc func scheduleDefault() {
    scheduleLocal(5.0)
  }
  
  @objc func scheduleLocal(_ alarmTime: Double) {
    
    registerCategories()
    
    let center = UNUserNotificationCenter.current()
    
    center.removeAllPendingNotificationRequests()
    
    let content = UNMutableNotificationContent()
    content.title = "Late wake up call"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese"
    content.categoryIdentifier = "alarm"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default
    
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
//    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alarmTime, repeats: false)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request)
    
    print("worked")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    if let customData = userInfo["customData"] as? String {
      print("Custom data received: \(customData)")
      
      switch response.actionIdentifier {
      case UNNotificationDefaultActionIdentifier:
        showMessage(title: "Hello", message: "Good morning.")
        print("Default identifier")
        
      case "show":
        print("Show more information...")
        showMessage(title: "About this App", message: "Not much to say it's a lesson app.")
        
      case "snooze":
        scheduleLocal(86400.00)
        showMessage(title: "Snooze Selected", message: "Alarm set 24 hours from now.")
        
      default:
        break
      }
    }
    
    completionHandler()
  }
  
  func showMessage (title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }

}

