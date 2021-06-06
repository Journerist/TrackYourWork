//
//  MouseMoveInteractor.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//
import SwiftUI
import Cocoa
import UserNotifications


protocol MouseMoveInteractorI {
    func watch()
    func setSessionType(sessionStartTime: Date, type: ScreenTimeType)
    func stopCurrentSessionAndCloseApp()
}

struct MouseMoveInteractor : MouseMoveInteractorI {
    
    private let appState: AppStateI
    private let screenTimeApplicationService: ScreenTimeApplicationService
    private let statisticsApplicationService: StatisticsApplicationService

    private let notificationDelegate: UNUserNotificationCenterDelegate;
    
    @State private var minutes: Int = 0
    @State private var hours: Int = 0
    @State private var notificationContent: UNMutableNotificationContent = UNMutableNotificationContent()

    
    init(appState: AppStateI,
         screenTimeApplicationService: ScreenTimeApplicationService,
         statisticsApplicationService: StatisticsApplicationService,
         notificationDelegate: NotificationDelegate) {

        self.appState = appState
        self.screenTimeApplicationService = screenTimeApplicationService
        self.statisticsApplicationService = statisticsApplicationService
        self.notificationDelegate = notificationDelegate
        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self.notificationDelegate
        
        self.notificationContent.title = "Welcome back!"
        self.notificationContent.subtitle = "Tell us if your time afk was working- or free-time"
        self.notificationContent.sound = UNNotificationSound.default
        self.notificationContent.categoryIdentifier = "MEETING_INVITATION"
        
    }
    
    func watch() {
        
        //app started, initial moment
        self.screenTimeApplicationService.startSession(type: ScreenTimeType.WORKING)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            var lastEvent:CFTimeInterval = 0
            lastEvent = CGEventSource.secondsSinceLastEventType(CGEventSourceStateID.hidSystemState, eventType: CGEventType(rawValue: ~0)!)
            print(lastEvent)
            
            self.appState.setWorkingTime(timeInterval: self.screenTimeApplicationService.getWorkingTime())
            self.appState.setWorkingTimeLeft(hoursLeft: self.statisticsApplicationService.getWorkingTimeLeftForCurrentWeek())
            
            self.appState.setUnknownClosedSessions(sessions: self.screenTimeApplicationService.getUnknownClosedSessions())
            
            print("working time: \(self.screenTimeApplicationService.getWorkingTime())")
            print("working time left: \(self.statisticsApplicationService.getWorkingTimeLeftForCurrentWeek())")
            print("unknown session: \(self.screenTimeApplicationService.getUnknownClosedSessions())")
            print("Not closed sessions: \(self.screenTimeApplicationService.getNotClosedSessions().count)")
            
            // flag if afk detected
            if (lastEvent > 180) {
                
                if (!appState.afk) {
                    appState.userIsAfk(newAfk: true)
                    // end active session
                    self.screenTimeApplicationService.endSession()
                    
                    // start new session, looks like user is afk, this enables us to decide later if this is working or pause time
                    self.screenTimeApplicationService.startSession(type: ScreenTimeType.UNKNOWN)
                }
                
            } else {
                // is working actively
            }
            
            if (appState.afk == true && lastEvent < 10) {
                print("send event: user is back")
                appState.userIsAfk(newAfk: false)
                
                // enf afk time
                self.screenTimeApplicationService.endSession()
                
                // start new session, user is back, but was afk, we track this time in between by starting a new session
                self.screenTimeApplicationService.startSession(type: ScreenTimeType.WORKING)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: self.notificationContent, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
    
    func setSessionType(sessionStartTime: Date, type: ScreenTimeType) {
        self.screenTimeApplicationService.setSessionType(sessionStartTime: sessionStartTime, type: type)
    }

    func stopCurrentSessionAndCloseApp() {
        self.screenTimeApplicationService.endSession()
        
        for runningApplication in NSWorkspace.shared.runningApplications {
                   
            let appName = runningApplication.localizedName
            if appName == "SwiftUIMenuBar" {
                runningApplication.terminate()
            }
        }
    }

}
