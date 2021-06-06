//
//  ScreenTimeApplicationService.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 30.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class ScreenTimeApplicationService {
    
    private let screenTimeRepository: ScreenTimeRepository
    
    init(screenTimeRepository: ScreenTimeRepository) {
        self.screenTimeRepository = screenTimeRepository
        
        let currentSession = self.screenTimeRepository.getCurrent()
        
        if (currentSession == nil) {
            self.screenTimeRepository.save(screenTime: ScreenTime())
        }
    }
    
    func startSession(type: ScreenTimeType) {
        let screenTime = screenTimeRepository.getCurrent()!
        
        screenTime.startSession(type: type)
        
        screenTimeRepository.save(screenTime: screenTime)
    }
    
    func endSession() {
        let screenTime = screenTimeRepository.getCurrent()!
        
        screenTime.endSession()
        
        screenTimeRepository.save(screenTime: screenTime)
    }
    
    func setLastEndedSessionType(type: ScreenTimeType) {
        let screenTime = screenTimeRepository.getCurrent()!
        
        screenTime.setLastClosedScreenTimeSessionType(type: type)
        
        screenTimeRepository.save(screenTime: screenTime)
    }
    
    func getWorkingTime() -> TimeInterval {
        let screenTime = screenTimeRepository.getCurrent()!
        
        return screenTime.calculateWorkingTime()
    }
    
    func getUnknownClosedSessions() -> [ScreenTimeSession] {
        let screenTime = screenTimeRepository.getCurrent()!
        return screenTime.getUnknownClosedSessions()
    }
    
    func getNotClosedSessions() -> [ScreenTimeSession] {
        let screenTime = screenTimeRepository.getCurrent()!
        return screenTime.getNotClosedSessions()
    }
    
    func setSessionType(sessionStartTime: Date, type: ScreenTimeType) {
        let screenTime = screenTimeRepository.getCurrent()!
        
        screenTime.setUnknownClosedSessionType(sessionStartTime: sessionStartTime, type: type)
        
        screenTimeRepository.save(screenTime: screenTime)
    }

    
}
