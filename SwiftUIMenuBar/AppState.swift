//
//  AppState.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import SwiftUI

protocol AppStateI {
    var workingTime: String {get}
    var workingTimeLeft: String {get}
    var unknownClosedSessions: [ScreenTimeSession] {get}
    
    var afk: Bool {get}
    func userIsAfk(newAfk: Bool)
    func setWorkingTime(timeInterval: TimeInterval)
    func setWorkingTimeLeft(hoursLeft: Float)
    func setUnknownClosedSessions(sessions: [ScreenTimeSession])
}

class AppState: ObservableObject, AppStateI {
    var workingTime: String = "-" {
        willSet {
            objectWillChange.send()
        }
    }
    
    var workingTimeLeft: String = "-" {
        willSet {
            objectWillChange.send()
        }
    }
    
    var unknownClosedSessions: [ScreenTimeSession] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    var afk: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }

    func userIsAfk(newAfk: Bool) {
        afk = newAfk
    }
    
    func setWorkingTime(timeInterval: TimeInterval) {
        workingTime = formatTimeInterval(duration: timeInterval)
    }
    
    func setWorkingTimeLeft(hoursLeft: Float) {
        let t: TimeInterval = Double(hoursLeft*60*60)
        workingTimeLeft = formatTimeInterval(duration: t)
    }
    
    func setUnknownClosedSessions(sessions: [ScreenTimeSession]) {
        unknownClosedSessions = sessions
    }

    
    private func formatTimeInterval(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2

        return formatter.string(from: duration)!
    }
}
