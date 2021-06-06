//
//  WorkingHoursLeftCalculator.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 02.06.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class WorkingHoursLeftCalculator {
    
    private let workdayCalculator: WorkdayCalculator
    
    init(workdayCalculator: WorkdayCalculator) {
        self.workdayCalculator = workdayCalculator
    }
    
    func calculateWorkingHoursLeftFor(date: Date, screenTime: ScreenTime) -> Float {
        let startDateOfTheWeek = workdayCalculator.getStartDateOfTheWeek(date: date)
        let workingDays = workdayCalculator.getPassedAndStartedWorkdayCountSince(date: date)
        
        let workingTimeSinceStartOfTheWeek = screenTime.calculateWorkingTime(since: startDateOfTheWeek)
        
        return (Float(workingDays) * 8) - Float(workingTimeSinceStartOfTheWeek) / 3600
    }
    
}
