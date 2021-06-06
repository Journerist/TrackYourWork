//
//  WorkingHoursLeftCalculatorTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 02.06.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class WorkingHoursLeftCalculatorTest: XCTestCase {

    private var workingHoursLeftCalculator: WorkingHoursLeftCalculator!
    
    override func setUpWithError() throws {
        self.workingHoursLeftCalculator = WorkingHoursLeftCalculator(
            workdayCalculator: WorkdayCalculator()
        )
    }
    
    func test_calculateWorkingHoursLeftFor_worked0hours() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
    
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: startDateOfTheWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 8)
    }
    
    func test_calculateWorkingHoursLeftFor_worked1hourLastWeek() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 24
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateLastWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateLastWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfLastWeekPlus1hour = startDateLastWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfLastWeekPlus1hour)
        screenTime.endSession()
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: startDateOfTheWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 8)
    }

    func test_calculateWorkingHoursLeftFor_worked1hour() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfTheWeekPlus1hour = startDateOfTheWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfTheWeekPlus1hour)
        screenTime.endSession()
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: startDateOfTheWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 7)
    }
    
    func test_calculateWorkingHoursLeftFor_day2ofTheWeek_worked1hour() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 3
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfTheWeekPlus1hour = startDateOfTheWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfTheWeekPlus1hour)
        screenTime.endSession()
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: startDateOfTheWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 15)
    }
    
    func test_calculateWorkingHoursLeftFor_day5ofTheWeek_worked1hour() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 4
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfTheWeekPlus1hour = startDateOfTheWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfTheWeekPlus1hour)
        screenTime.endSession()
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: startDateOfTheWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 39)
    }
    
    func test_calculateWorkingHoursLeft_endOfWeek_areKeptUntilEndOfWeek() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 4
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfTheWeekPlus1hour = startDateOfTheWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfTheWeekPlus1hour)
        screenTime.endSession()
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 6
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let enfOfWeek = calendar.date(from: dateComponents)!
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: enfOfWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 39)
    }
    
    func test_calculateWorkingHoursLeft_nextWeek_resetsHourCount() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 4
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let screenTime = ScreenTime()
        
        screenTime.setCurrentDate(date: startDateOfTheWeek)
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let startDateOfTheWeekPlus1hour = startDateOfTheWeek + 60*60
        screenTime.setCurrentDate(date: startDateOfTheWeekPlus1hour)
        screenTime.endSession()
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 7
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let enfOfWeek = calendar.date(from: dateComponents)!
        
        let workingHoursLeftCount = workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: enfOfWeek, screenTime: screenTime)
        
        XCTAssertEqual(workingHoursLeftCount, 8)
    }



}
