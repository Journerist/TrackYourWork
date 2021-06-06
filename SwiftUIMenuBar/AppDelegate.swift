//
//  AppDelegate.swift
//  SwiftUIMenuBar
//
//  Created by Aaron Wright on 12/18/19.
//  Copyright © 2019 Aaron Wright. All rights reserved.
//

import Cocoa
import SwiftUI
import Swinject
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    let container = Container() { container in
        
        try! SqliteDatabase(dbName: "production_v5").setupDatabase()
        
        // Infrastructure
        container.register(SqliteDatabase.self) { _ in try! SqliteDatabase(dbName: "production_v5") }
        container.register(NotificationDelegate.self) { r in
            NotificationDelegate(screenTimeApplicationService: r.resolve(ScreenTimeApplicationService.self)!)
            
        }
        
        // Dao
        container.register(KeyValueDao.self) {
            r in KeyValueDao(
                db: r.resolve(SqliteDatabase.self)!
            )
        }
        
        // Repositories
        container.register(ScreenTimeRepository.self) {
            r in ScreenTimeRepository(
                keyValueDao: r.resolve(KeyValueDao.self)!
            )
        }
        
        // Domain services
        container.register(WorkdayCalculator.self) {
            r in WorkdayCalculator()
        }
        container.register(WorkingHoursLeftCalculator.self) {
            r in WorkingHoursLeftCalculator(workdayCalculator: r.resolve(WorkdayCalculator.self)!)
        }
        
        // Application services
        container.register(ScreenTimeApplicationService.self) {
            r in ScreenTimeApplicationService(
                screenTimeRepository: r.resolve(ScreenTimeRepository.self)!
            )
        }
        container.register(StatisticsApplicationService.self) {
            r in StatisticsApplicationService(
                screenTimeRepository: r.resolve(ScreenTimeRepository.self)!,
                workingHoursLeftCalculator: r.resolve(WorkingHoursLeftCalculator.self)!
            )
        }
        
        // Model
        container.register(AppState.self) { _ in AppState() }

        // Interactors
        container.register(MouseMoveInteractorI.self) { r in MouseMoveInteractor(
            appState: r.resolve(AppState.self)!,
            screenTimeApplicationService: r.resolve(ScreenTimeApplicationService.self)!,
            statisticsApplicationService: r.resolve(StatisticsApplicationService.self)!,
            notificationDelegate: r.resolve(NotificationDelegate.self)!
        ) }
    
        // Views
        container.register(ContentView.self) { r in ContentView(appState: r.resolve(AppState.self)!, mouseMoveInteractor: r.resolve(MouseMoveInteractorI.self)!) }
    }
        
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = container.resolve(ContentView.self)

        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "-")
            button.action = #selector(togglePopover(_:))
            //button.insertText("hello")
        }
        
        setupApplicationToolbarIconText()
        
        registerForPushNotifications()
        
        do {
            try SqliteDatabase(dbName: "production").setupDatabase()
        } catch  {
            print("Sqlite creation failed: \(error).")
        }
        
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func setupApplicationToolbarIconText() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true){ tempTimer in
            if let button = self.statusBarItem.button {
                button.title = self.formatTimeInterval(workingHoursLeft:
                                                    (self.container.resolve(StatisticsApplicationService.self)!).getWorkingTimeLeftForCurrentWeek())
            }
        }.fire()
        
    }
    
    private func formatTimeInterval(workingHoursLeft: Float) -> String {
        let duration = Double(workingHoursLeft) * 60 * 60
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2

        return formatter.string(from: duration)!
    }
    
    func registerForPushNotifications() {
      //1
      UNUserNotificationCenter.current()
        //2
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            //3
            print("Permission granted: \(granted)")
            
            if let error = error {
                // Handle the error here.
                print(error)
            }
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
}

