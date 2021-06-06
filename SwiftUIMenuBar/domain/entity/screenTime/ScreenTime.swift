//
//  ScreenTime.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 23.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class ScreenTime: Equatable, Codable {
    
    private var activeScreenTimeSession: ScreenTimeSession? = nil
    private var openScreenTimeSessions: [ScreenTimeSession] = []
    private var closedScreenTimeSessions: [ScreenTimeSession] = []
    
    private var overriddenCurrentDate: Date? = nil
    
    static func == (lhs: ScreenTime, rhs: ScreenTime) -> Bool {
        return
            lhs.activeScreenTimeSession == rhs.activeScreenTimeSession &&
            lhs.openScreenTimeSessions == rhs.openScreenTimeSessions &&
            lhs.closedScreenTimeSessions == rhs.closedScreenTimeSessions
    }

    
    func hasActiveSession() -> Bool {
        return activeScreenTimeSession != nil
    }
    
    func startSession(type: ScreenTimeType) {
        if (activeScreenTimeSession != nil) {
            openScreenTimeSessions.append(activeScreenTimeSession!)
        }
            
        activeScreenTimeSession = ScreenTimeSession(startDate: getCurrentDate(), type: type)
    }
    
    func setActiveSessionType(type: ScreenTimeType) {
        if (activeScreenTimeSession != nil) {
            activeScreenTimeSession!.setType(type: type)
        }
    }
    
    func getActiveSessionStartTime() -> Date? {
        return activeScreenTimeSession?.getStart()
    }
    
    func getClosedScreenTimeSessions() -> [ScreenTimeSession] {
        return closedScreenTimeSessions
    }
    
    func getOpenScreenTimeSessions() -> [ScreenTimeSession] {
        return openScreenTimeSessions
    }
    
    func endSession() {
        
        if activeScreenTimeSession == nil {
            print("Can not end session - no session active")
        } else {
            activeScreenTimeSession?.setEnd(end: getCurrentDate())
            closedScreenTimeSessions.append(activeScreenTimeSession!)
            activeScreenTimeSession = nil
        }
    }
    
    func setLastClosedScreenTimeSessionType(type: ScreenTimeType) {
        if (closedScreenTimeSessions.last != nil) {
            closedScreenTimeSessions.last!.setType(type: type)
        }
    }
    
    func getUnknownClosedSessions() -> [ScreenTimeSession] {
        
        return closedScreenTimeSessions.filter {
            session in session.isUnknownTime()
        }
        
    }
    
    func setUnknownClosedSessionType(sessionStartTime: Date, type: ScreenTimeType) {
        closedScreenTimeSessions.filter {
            session in session.getStart() == sessionStartTime
        }.forEach {
            session in session.setType(type: type)
        }
    }
    
    func getNotClosedSessions() -> [ScreenTimeSession] {
        return (closedScreenTimeSessions + openScreenTimeSessions).filter{
                session in session.getEnd() == nil
        }
        
    }
    
    func calculateWorkingTime() -> TimeInterval {
        return calculateWorkingTime(since: Date.init(timeIntervalSince1970: 0))
    }
    
    
    func calculateWorkingTime(since: Date) -> TimeInterval {
        var workTime = TimeInterval.init()
        for closedSession in closedScreenTimeSessions {
            if (closedSession.isWorkingTime() && closedSession.getStart() >= since) {
                workTime += closedSession.getTimeInterval()
            }
        }
        
        if (activeScreenTimeSession != nil && activeScreenTimeSession!.isWorkingTime()) {
            workTime += activeScreenTimeSession!.getTimeInterval()
        }
        
        return workTime
    }

    
    private func getCurrentDate() -> Date {
        if (overriddenCurrentDate != nil) {
            return overriddenCurrentDate!
        } else {
            return Date()
        }
    }
    
    internal func setCurrentDate(date: Date) {
        self.overriddenCurrentDate = date
        
        if (activeScreenTimeSession != nil) {
            activeScreenTimeSession!.setCurrentDate(date: date)
        }
    }
    
}
