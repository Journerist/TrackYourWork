//
//  ScreenTimeSession.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 23.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class ScreenTimeSession: Equatable, Codable, Identifiable {
    
    private var startDate: Date
    private var endDate: Date?
    private var type: ScreenTimeType = ScreenTimeType.UNKNOWN
    
    private var overriddenCurrentDate: Date? = nil
    
    static func == (lhs: ScreenTimeSession, rhs: ScreenTimeSession) -> Bool {
        return
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate
    }
    
    init(startDate: Date) {
        self.startDate = startDate
    }
    
    init(startDate: Date, type: ScreenTimeType) {
        self.startDate = startDate
        self.type = type
    }
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(startDate: Date, endDate: Date, type: ScreenTimeType) {
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
    }
    
    func setType(type: ScreenTimeType) {
        self.type = type
    }
    
    func hasEnd() -> Bool {
        return endDate != nil
    }
    
    func setEnd(end: Date) {
        self.endDate = end
    }
    
    func getEnd() -> Date? {
        return self.endDate
    }
    
    func getStart() -> Date {
        return self.startDate
    }
    
    func equals(screenTimeSession: ScreenTimeSession?) -> Bool {
        return self.startDate == screenTimeSession?.startDate
            && self.endDate == screenTimeSession?.endDate
    }
    
    func getTimeInterval() -> TimeInterval {
        if (endDate != nil) {
            return endDate!.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        } else {
            return getCurrentDate().timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
        }
    }
    
    func isWorkingTime() -> Bool {
        return type == ScreenTimeType.WORKING
    }
    
    func isUnknownTime() -> Bool {
        return type == ScreenTimeType.UNKNOWN
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
    }
}
