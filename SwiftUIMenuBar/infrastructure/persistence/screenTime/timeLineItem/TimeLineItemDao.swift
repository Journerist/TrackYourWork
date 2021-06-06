//
//  TimeLineRepository.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 21.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation
import SQLite

class TimeLineItemDao {
    
    private var db: SqliteDatabase
    
    init(db: SqliteDatabase) {
        self.db = db
    }
    
    func insertTimeLineItem() throws {
        let now = Date()
        
        let timeLineItemTable = Table("time_line_item")
        let id = Expression<String>("id")
        let startDateTime = Expression<Date>("starDateTime")
        let endDateTime = Expression<Date?>("endDateTime")
        let timeLineItemtype = Expression<String>("type")
        
        let insert = timeLineItemTable.insert(
            id <- UUID.init().uuidString,
            startDateTime <- now,
            endDateTime <- now,
            timeLineItemtype <- TimeLineItemType.TBD.rawValue)

        try self.db.getConnection().run(insert)
        
    }
    
    func save(timeLineItem: TimeLineItemRecord) {
   
        let timeLineItemTable = Table("time_line_item")
        let id = Expression<String>("id")
        let startDateTime = Expression<Date>("starDateTime")
        let endDateTime = Expression<Date?>("endDateTime")
        let timeLineItemtype = Expression<String>("type")
        
        let insert = timeLineItemTable.insert(
            id <- timeLineItem.getId().uuidString,
            startDateTime <- timeLineItem.getStartTime(),
            endDateTime <- timeLineItem.getEndTime(),
            timeLineItemtype <- timeLineItem.getType().rawValue)

        do {
            try self.db.getConnection().run(insert)
        } catch {
            print("Could not store timeLineItem \(timeLineItem): \(error)")
        }
    }
    
    func findAll() -> [TimeLineItemRecord] {
        let timeLineItemTable = Table("time_line_item")
        let tableId = Expression<String>("id")
        let tableStartDateTime = Expression<Date>("starDateTime")
        let tableEndDateTime = Expression<Date?>("endDateTime")
        let tableTimeLineItemtype = Expression<String>("type")
        
        let findQuery = timeLineItemTable.select(timeLineItemTable[*])
    
        var items: [TimeLineItemRecord] = []
        
        for item in try! self.db.getConnection().prepare(findQuery) {
            let item: TimeLineItemRecord = TimeLineItemRecord(
                id: UUID(uuidString: item[tableId])!,
                startTime: item[tableStartDateTime],
                endTime: item[tableEndDateTime],
                type: TimeLineItemType.init(rawValue: item[tableTimeLineItemtype])!
            )
            
            items.append(item)
        }
        
        return items
    }
    
    func findBy(type: TimeLineItemType) -> [TimeLineItemRecord] {
        let timeLineItemTable = Table("time_line_item")
        let tableId = Expression<String>("id")
        let tableStartDateTime = Expression<Date>("starDateTime")
        let tableEndDateTime = Expression<Date?>("endDateTime")
        let tableTimeLineItemtype = Expression<String>("type")
        
        let findByTypeQuery = timeLineItemTable.select(timeLineItemTable[*]).where(tableTimeLineItemtype == type.rawValue)
    
        var items: [TimeLineItemRecord] = []
        
        for item in try! self.db.getConnection().prepare(findByTypeQuery) {
            let item: TimeLineItemRecord = TimeLineItemRecord(
                id: UUID(uuidString: item[tableId])!,
                startTime: item[tableStartDateTime],
                endTime: item[tableEndDateTime],
                type: TimeLineItemType.init(rawValue: item[tableTimeLineItemtype])!
            )
            
            items.append(item)

        }
        
        return items
        
    }
    
    func findBy(id: UUID) -> TimeLineItemRecord? {
        let timeLineItemTable = Table("time_line_item")
        let tableId = Expression<String>("id")
        let tableStartDateTime = Expression<Date>("starDateTime")
        let tableEndDateTime = Expression<Date?>("endDateTime")
        let tableTimeLineItemtype = Expression<String>("type")
        
        let findByIdQuery = timeLineItemTable.select(timeLineItemTable[*]).where(tableId == id.uuidString)
    
        
        for item in try! self.db.getConnection().prepare(findByIdQuery) {
            let item: TimeLineItemRecord = TimeLineItemRecord(
                id: UUID(uuidString: item[tableId])!,
                startTime: item[tableStartDateTime],
                endTime: item[tableEndDateTime],
                type: TimeLineItemType.init(rawValue: item[tableTimeLineItemtype])!
            )
            
            return item
        
        }
        
        return nil
        
    }
    
}
