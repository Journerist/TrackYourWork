//
//  TimeLineItemDaoTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 22.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class TimeLineItemDaoTest: XCTestCase {

    var db: SqliteDatabase!
    var dao: TimeLineItemDao!
    
    override func setUpWithError() throws {
        self.db = try SqliteDatabase(dbName: "TimeLineItemDaoTest")
        try db.setupDatabase();
        self.dao = TimeLineItemDao(db: db)
    }

    override func tearDownWithError() throws {
        db.delete();
    }

    func test_blankTimeLineItem_isStored() throws {
        let item = TimeLineItemRecord()
        
        self.dao.save(timeLineItem: TimeLineItemRecord())
        self.dao.save(timeLineItem: TimeLineItemRecord())
        self.dao.save(timeLineItem: TimeLineItemRecord())
        
        self.dao.save(timeLineItem: item)
        let storedItem = self.dao.findBy(id: item.getId())!
        
        XCTAssertEqual(storedItem.getId(), item.getId())
        XCTAssertEqual(storedItem.getType(), item.getType())
        XCTAssertEqual(storedItem.getStartTime().description, item.getStartTime().description)
        XCTAssertEqual(storedItem.getEndTime(), item.getEndTime())
    }
    
    func test_fullTimeLineItem_isStored() throws {
        let item = TimeLineItemRecord()
        item.setEndTimeNow(type: TimeLineItemType.WORK)
        
        self.dao.save(timeLineItem: TimeLineItemRecord())
        self.dao.save(timeLineItem: TimeLineItemRecord())
        self.dao.save(timeLineItem: TimeLineItemRecord())
        
        self.dao.save(timeLineItem: item)
        
        let storedItem = self.dao.findBy(id: item.getId())!
        
        XCTAssertEqual(storedItem.getId(), item.getId())
        XCTAssertEqual(storedItem.getType(), item.getType())
        XCTAssertEqual(storedItem.getStartTime().description, item.getStartTime().description)
        XCTAssertEqual(storedItem.getEndTime()!.description, item.getEndTime()!.description)
    }
    
    func test_findAll_returnsAll() throws {
        
        let item1 = TimeLineItemRecord()
        let item2 = TimeLineItemRecord()
        let item3 = TimeLineItemRecord()
        
        self.dao.save(timeLineItem: item1)
        self.dao.save(timeLineItem: item2)
        self.dao.save(timeLineItem: item3)
        
        let items: [TimeLineItemRecord] = self.dao.findAll()
        
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].getId(), item1.getId())
        XCTAssertEqual(items[1].getId(), item2.getId())
        XCTAssertEqual(items[2].getId(), item3.getId())
    }
    
    func test_findNoMatchingType_returnsEmptyList() throws {
        
        let item1 = TimeLineItemRecord()
        let item2 = TimeLineItemRecord()
        let item3 = TimeLineItemRecord()
        item3.setEndTimeNow(type: TimeLineItemType.PAUSE)
        
        self.dao.save(timeLineItem: item1)
        self.dao.save(timeLineItem: item2)
        self.dao.save(timeLineItem: item3)
        
        let items: [TimeLineItemRecord] = self.dao.findBy(type: TimeLineItemType.WORK)
        
        XCTAssertEqual(items.count, 0)
    }
    
    func test_findByType_returnsWithMatchingType() throws {
        
        let item1 = TimeLineItemRecord()
        let item2 = TimeLineItemRecord()
        let item3 = TimeLineItemRecord()
        item3.setEndTimeNow(type: TimeLineItemType.WORK)
        
        self.dao.save(timeLineItem: item1)
        self.dao.save(timeLineItem: item2)
        self.dao.save(timeLineItem: item3)
        
        let items: [TimeLineItemRecord] = self.dao.findBy(type: TimeLineItemType.WORK)
        
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].getId(), item3.getId())
    }

}
