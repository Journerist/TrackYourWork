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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    let container = Container() { container in
            // Model
            container.register(AppState.self) { _ in AppState() }

            // Interactors
            container.register(MouseMoveInteractorI.self) { r in MouseMoveInteractor(appState: r.resolve(AppState.self)!) }
        
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
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        
        NSApp.activate(ignoringOtherApps: true)
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

