//
//  TimeLineItem.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 21.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class TimeLineItemRecord {

   private var id: UUID
   private var startTime: Date
   private var endTime: Date?
   private var type = TimeLineItemType.TBD
    
    init() {
        self.id = UUID.init()
        self.startTime = Date.init()
    }
    
    init(id: UUID, startTime: Date, endTime: Date?, type: TimeLineItemType) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.type = type
    }
    
    func getId() -> UUID {
        return self.id;
    }
    
    func getStartTime() -> Date {
        return self.startTime;
    }
    
    func getEndTime() -> Date? {
        return self.endTime;
    }
    
    func setEndTimeNow(type: TimeLineItemType) {
        self.endTime = Date.init()
        self.type = type
    }
    
    func getType() -> TimeLineItemType {
        return self.type
    }
}
