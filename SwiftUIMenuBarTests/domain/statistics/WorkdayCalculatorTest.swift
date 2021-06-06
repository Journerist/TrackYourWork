//
//  WorkdayCalculatorTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 02.06.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class WorkdayCalculatorTest: XCTestCase {

    var workdayCalculator: WorkdayCalculator!
    
    override func setUpWithError() throws {
        workdayCalculator = WorkdayCalculator()
    }

    func test_getDateWithoutTime_monday_shouldReturnSameDate() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        let startDateOfTheWeekCalculated = workdayCalculator.getStartDateOfTheWeek(date: startDateOfTheWeek)
        
        XCTAssertEqual(startDateOfTheWeekCalculated, startDateOfTheWeek)
    }
    
    func test_getDateWithoutTime_mondayAfternoon_shouldReturnSameDayWithoutTime() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 16
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startDateOfTheWeekCalculated = workdayCalculator.getStartDateOfTheWeek(date: startDateOfTheWeekAfternoon)
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        XCTAssertEqual(startDateOfTheWeekCalculated, startDateOfTheWeek)
    }
    
    func test_getDateWithoutTime_tuesdayAfternoon_shouldReturnSameDayWithoutTime() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 16
        dateComponents.minute = 0
        dateComponents.second = 0
        let tuesday = calendar.date(from: dateComponents)!
        
        let startDateOfTheWeekCalculated = workdayCalculator.getStartDateOfTheWeek(date: tuesday)
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        XCTAssertEqual(startDateOfTheWeekCalculated, startDateOfTheWeek)
    }
    
    func test_getDateWithoutTime_sundayAfternoon_shouldReturnSameDayWithoutTime() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 6
        dateComponents.hour = 23
        dateComponents.minute = 0
        dateComponents.second = 0
        let tuesday = calendar.date(from: dateComponents)!
        
        let startDateOfTheWeekCalculated = workdayCalculator.getStartDateOfTheWeek(date: tuesday)
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        XCTAssertEqual(startDateOfTheWeekCalculated, startDateOfTheWeek)
    }
    
    func test_getDateWithoutTime_sundayAfternoonMonday_shouldReturnSameDayWithoutTime() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 7
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let tuesday = calendar.date(from: dateComponents)!
        
        let startDateOfTheWeekCalculated = workdayCalculator.getStartDateOfTheWeek(date: tuesday)
        
        dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 7
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeek = calendar.date(from: dateComponents)!
        
        XCTAssertEqual(startDateOfTheWeekCalculated, startDateOfTheWeek)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_monday_returns1() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 1)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_mondayLateNight_returns1() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 31
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 1)
    }

    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_tuesday_returns2() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 2)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_tuesdayNight_returns2() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 1
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 2)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_friday_returns5() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 4
        dateComponents.hour = 16
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 5)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_sunday_returns5() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 6
        dateComponents.hour = 16
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 5)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_sundayLateNight_returns5() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 6
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 5)
    }
    
    func test_getPassedAndStartedWorkdayCountForCurrentWeek_sundayLateNightMonday_returns1() throws {
        let calendar = Calendar(identifier: .gregorian)

        var dateComponents = DateComponents()
        dateComponents.year = 2021
        dateComponents.month = 6
        dateComponents.day = 7
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        let startDateOfTheWeekAfternoon = calendar.date(from: dateComponents)!
        
        let startedWorkdayCount = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: startDateOfTheWeekAfternoon)

        
        XCTAssertEqual(startedWorkdayCount, 1)
    }
}
