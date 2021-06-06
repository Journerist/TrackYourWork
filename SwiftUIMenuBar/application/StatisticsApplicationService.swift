//
//  StatisticsApplicationService.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 02.06.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class StatisticsApplicationService {
    
    private let screenTimeRepository: ScreenTimeRepository
    private let workingHoursLeftCalculator: WorkingHoursLeftCalculator
    
    init(screenTimeRepository: ScreenTimeRepository, workingHoursLeftCalculator: WorkingHoursLeftCalculator) {
        self.screenTimeRepository = screenTimeRepository
        self.workingHoursLeftCalculator = workingHoursLeftCalculator

        let currentSession = self.screenTimeRepository.getCurrent()
        
        if (currentSession == nil) {
            self.screenTimeRepository.save(screenTime: ScreenTime())
        }
    }
    
    func getWorkingTimeLeftForCurrentWeek() -> Float {
        let screenTime = screenTimeRepository.getCurrent()!
        
        return workingHoursLeftCalculator.calculateWorkingHoursLeftFor(date: Date(), screenTime: screenTime)
    }
}
