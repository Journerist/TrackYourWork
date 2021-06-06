//
//  ScreenTimeTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 23.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class ScreenTimeTest: XCTestCase {

    private var screenTime: ScreenTime!
    
    override func setUpWithError() throws {
        self.screenTime = ScreenTime()
    }

    override func tearDownWithError() throws {
    }

    func test_initial_hasNoActiveSession() throws {
        XCTAssertEqual(screenTime.hasActiveSession(), false)
    }
    
    func test_startedSession_hasActiveSession() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        XCTAssertEqual(screenTime.hasActiveSession(), true)
    }
    
    func test_startedSession_hasStartTime() throws {
        let beforeSessionStartDate = Date()
        screenTime.startSession(type: ScreenTimeType.WORKING)
        XCTAssertTrue(screenTime.getActiveSessionStartTime()! <= Date())
        XCTAssertTrue(screenTime.getActiveSessionStartTime()! >= beforeSessionStartDate)
    }
    
    func test_initial_hasNoPastSessions() throws {
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions().count, 0)
    }
    
    func test_startedSession_hasNoClosedSessions() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions().count, 0)
    }
    
    func test_startSession_endSession_addsSessionWithEndTimeToClosedSessions() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let beforeEndStartDate = Date()
        screenTime.endSession()

        XCTAssertEqual(screenTime.getClosedScreenTimeSessions().count, 1)
        XCTAssertTrue(screenTime.getClosedScreenTimeSessions()[0].getEnd()! <= Date())
        XCTAssertTrue(screenTime.getClosedScreenTimeSessions()[0].getEnd()! >= beforeEndStartDate)
    }
    
    func test_endSessionWhenNotStarted_nothingHappens() throws {
        self.screenTime.endSession()
    }
    
    func test_startSessionWhenAlreadyStarted_newSessionIsStarted() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let firstSessionStartTime = self.screenTime.getActiveSessionStartTime()!
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        XCTAssertNotEqual(firstSessionStartTime, screenTime.getActiveSessionStartTime()!)
    }
    
    func test_startSessionWhenAlreadyStarted_newOpenScreenTimeSessionIsAdded() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let firstSessionStartTime = self.screenTime.getActiveSessionStartTime()!
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions().count, 0)
        XCTAssertEqual(screenTime.getOpenScreenTimeSessions().count, 1)
        XCTAssertEqual(screenTime.getOpenScreenTimeSessions()[0].getStart(), firstSessionStartTime)
    }
    
    func test_startSessionsEndSessions() throws {
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let firstSessionStartTime = self.screenTime.getActiveSessionStartTime()!
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let secondSessionStartTime = self.screenTime.getActiveSessionStartTime()!
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let firstOpenSession = self.screenTime.getActiveSessionStartTime()!
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let secondOpenSession = self.screenTime.getActiveSessionStartTime()!
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let thirdClosedSessionStartTime = self.screenTime.getActiveSessionStartTime()!
        screenTime.endSession()
        
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions().count, 3)
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions()[0].getStart(), firstSessionStartTime)
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions()[1].getStart(), secondSessionStartTime)
        XCTAssertEqual(screenTime.getClosedScreenTimeSessions()[2].getStart(), thirdClosedSessionStartTime)
        
        XCTAssertEqual(screenTime.getOpenScreenTimeSessions().count, 2)
        XCTAssertEqual(screenTime.getOpenScreenTimeSessions()[0].getStart(), firstOpenSession)
        XCTAssertEqual(screenTime.getOpenScreenTimeSessions()[1].getStart(), secondOpenSession)
    }
    
    func test_equalsAfterInit_true() throws {
        let screenTime1 = ScreenTime()
        let screenTime2 = ScreenTime()
        
        XCTAssertEqual(screenTime1, screenTime2)
    }
    
    func test_oneOfTwoStarted_doesNotEqual() throws {
        let screenTime1 = ScreenTime()
        let screenTime2 = ScreenTime()
        screenTime2.startSession(type: ScreenTimeType.WORKING)
        
        XCTAssertNotEqual(screenTime1, screenTime2)
    }
    
    func test_bothStartedButHaveDifferentTimes_doesNotEqual() throws {
        let screenTime1 = ScreenTime()
        screenTime1.startSession(type: ScreenTimeType.WORKING)
        
        let screenTime2 = ScreenTime()
        screenTime2.startSession(type: ScreenTimeType.WORKING)
        
        XCTAssertNotEqual(screenTime1, screenTime2)
    }
    
    func test_bothStoppedButHaveDifferentTimes_doesNotEqual() throws {
        let screenTime1 = ScreenTime()
        screenTime1.startSession(type: ScreenTimeType.WORKING)
        screenTime1.endSession()
        
        let screenTime2 = ScreenTime()
        screenTime2.endSession()
        
        XCTAssertNotEqual(screenTime1, screenTime2)
    }
    
    func test_contains_closedSessios_calculateWorkingTime() throws {
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        
        screenTime.endSession()
        
        let timeElapsed: TimeInterval = currentDatePlus1hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate

        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_contains_singleOpenSession_calculateWorkingTime() throws {
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
                
        let timeElapsed: TimeInterval = currentDatePlus1hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate

        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_contains_openSessionAndClosedSession_calculateWorkingTime() throws {
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
                
        let timeElapsed: TimeInterval = currentDatePlus2hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate

        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_noWorkingTime_openSessionAndClosedSession_containsNoWorkingTime() throws {
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.UNKNOWN)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.UNKNOWN)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
                
        XCTAssertEqual(screenTime.calculateWorkingTime(), 0)
    }
    
    func test_pausePartlyTime_openSessionAndClosedSession_containsNoWorkingTime() throws {
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.PAUSE)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
        
        let timeElapsed: TimeInterval = currentDatePlus1hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
                
        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_findUnknownSessions_returnsUnknownSessions() {
        
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.UNKNOWN)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
        screenTime.endSession()
                        
        XCTAssertEqual(screenTime.getUnknownClosedSessions().count, 1)
        XCTAssertEqual(screenTime.getUnknownClosedSessions()[0].getStart(), currentDate)
        
    }
    
    func test_setUnknownClosedSessionDelayedToWork_sumsUpAllWorkTime() {
        
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.UNKNOWN)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
        screenTime.endSession()
        
        screenTime.setUnknownClosedSessionType(sessionStartTime: currentDate, type: ScreenTimeType.WORKING)
                        
        XCTAssertEqual(screenTime.getUnknownClosedSessions().count, 0)
        
        let timeElapsed: TimeInterval = currentDatePlus2hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_setUnknownClosedSessionDelayedToPause_sumsUpAllWorkTime() {
        
        let currentDate = Date()
        
        screenTime.setCurrentDate(date: currentDate)
        screenTime.startSession(type: ScreenTimeType.UNKNOWN)
        
        let currentDatePlus1hour = currentDate + 60*60
        screenTime.setCurrentDate(date: currentDatePlus1hour)
        screenTime.endSession()
        
        screenTime.startSession(type: ScreenTimeType.WORKING)
        let currentDatePlus2hour = currentDate + 120*60
        screenTime.setCurrentDate(date: currentDatePlus2hour)
        screenTime.endSession()
        
        screenTime.setUnknownClosedSessionType(sessionStartTime: currentDate, type: ScreenTimeType.PAUSE)
                        
        XCTAssertEqual(screenTime.getUnknownClosedSessions().count, 0)
        
        let timeElapsed: TimeInterval = currentDatePlus1hour.timeIntervalSinceReferenceDate - currentDate.timeIntervalSinceReferenceDate
        XCTAssertEqual(screenTime.calculateWorkingTime(), timeElapsed)
    }
    
    func test_workingTimeSinceDate_sumsUpWorkingTime() {
        
        let calendar = Calendar(identifier: .gregorian)
        
        // Monday, 31. Mai - start of the week
        
        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let currentDate = calendar.date(from: dateComponents)!
        
        let currentDatePlus8hours = currentDate + 60*8*60
        
        screenTime.setCurrentDate(date: currentDatePlus8hours)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus9hour = currentDate + 60*9*60
        screenTime.setCurrentDate(date: currentDatePlus9hour)
        screenTime.endSession()
        
                        
        let timeElapsed: TimeInterval = currentDatePlus9hour.timeIntervalSinceReferenceDate - currentDatePlus8hours.timeIntervalSinceReferenceDate
        
        let workingTimeSinceDate = screenTime.calculateWorkingTime(since: currentDate)
        
        XCTAssertEqual(workingTimeSinceDate, timeElapsed)
    }
    
    func test_workingTimeSinceDate_sumsUpOnlyWorkingTimeSinceTheDate() {
        
        let calendar = Calendar(identifier: .gregorian)
        
        // Monday, 30. Mai - Sunday, before the next week
        
        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 30
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let beforeStartOfTheWeek = calendar.date(from: dateComponents)!
        
        screenTime.setCurrentDate(date: beforeStartOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let beforeStartOfTheWeekPlus1Hour = beforeStartOfTheWeek + 60*1*60
        screenTime.setCurrentDate(date: beforeStartOfTheWeekPlus1Hour)
        screenTime.endSession()
        
        
        // Monday, 31. Mai - start of the week
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let currentDate = calendar.date(from: dateComponents)!
        
        let currentDatePlus8hours = currentDate + 60*8*60
        
        screenTime.setCurrentDate(date: currentDatePlus8hours)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let currentDatePlus9hour = currentDate + 60*9*60
        screenTime.setCurrentDate(date: currentDatePlus9hour)
        screenTime.endSession()
        
                        
        let timeElapsed: TimeInterval = currentDatePlus9hour.timeIntervalSinceReferenceDate - currentDatePlus8hours.timeIntervalSinceReferenceDate
        
        let workingTimeSinceDate = screenTime.calculateWorkingTime(since: currentDate)
        
        XCTAssertEqual(workingTimeSinceDate, timeElapsed)
    }

}
