//
//  WorkdayCalculator.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 02.06.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class WorkdayCalculator {
    

    func getStartDateOfTheWeek(date: Date) -> Date {
        
        let dateWithoutTime = getDateWithoutTime(from: date)
        
        return dateWithoutTime
    }
    
    private func getDateWithoutTime(from originalDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: originalDate)
        let date = Calendar.current.date(from: components)!
        
        // +5 with mod to have 0 - monday, 1 - tuesday, ..., 6 - sunday
        let weekday = (components.weekday! + 5) % 7

        let startOfTheWeek = Calendar.current.date(byAdding: .day, value: weekday * -1, to: date)!
        
        return startOfTheWeek
    }
    
    func getPassedAndStartedWorkdayCountSince(date: Date) -> Int {
        let startDateOfTheWeek = self.getStartDateOfTheWeek(date: date)
        
        return min(Calendar.current.dateComponents([.day], from: startDateOfTheWeek, to: date).day! + 1, 5)

    }
}
