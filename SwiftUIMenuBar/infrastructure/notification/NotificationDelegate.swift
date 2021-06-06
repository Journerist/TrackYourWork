//
//  NotificationDelegate.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 30.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    let screenTimeApplicationService: ScreenTimeApplicationService
    
    init(screenTimeApplicationService: ScreenTimeApplicationService) {
        self.screenTimeApplicationService = screenTimeApplicationService
        
        super.init()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           didReceive response: UNNotificationResponse,
           withCompletionHandler completionHandler:
             @escaping () -> Void) {
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Took a break 👯‍♂️",
              options: UNNotificationActionOptions(rawValue: 0))
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Worked hard 👨‍💻",
              options: UNNotificationActionOptions(rawValue: 0))
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "MEETING_INVITATION",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        center.setNotificationCategories([meetingInviteCategory])
           
       // Get the meeting ID from the original notification.
       //let userInfo = response.notification.request.content.userInfo
        
       // Perform the task associated with the action.
       switch response.actionIdentifier {
       case "ACCEPT_ACTION":
        self.screenTimeApplicationService.setLastEndedSessionType(type: ScreenTimeType.PAUSE)
          break
            
       case "DECLINE_ACTION":
          self.screenTimeApplicationService.setLastEndedSessionType(type: ScreenTimeType.WORKING)
          break
            
       // Handle other actions…
     
       default:
          self.screenTimeApplicationService.setLastEndedSessionType(type: ScreenTimeType.WORKING)
          break
       }
        
       // Always call the completion handler when done.
       completionHandler()
    }
    
    
}
