//
//  MouseMoveInteractor.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//
import SwiftUI
import Cocoa

protocol MouseMoveInteractorI {
    func watch()
}

struct MouseMoveInteractor : MouseMoveInteractorI {
    
    let appState: AppStateI
    
    init(appState: AppStateI) {
        self.appState = appState
    }
    
    func watch() {
        

        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            self.appState.incrementMouseCounter()
        }
        
        print("Watching....\(self.appState.mouseMoveCounter)")
    }
}
