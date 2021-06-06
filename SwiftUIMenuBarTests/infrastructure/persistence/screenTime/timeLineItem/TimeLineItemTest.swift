//
//  TimeLineItemTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 21.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class TimeLineItemTest: XCTestCase {
    
    var item: TimeLineItemRecord!
    var beforeInstanceCreationTime = Date()
    var afterInstanceCreationTime: Date!

    override func setUpWithError() throws {
        item = TimeLineItemRecord()
        afterInstanceCreationTime = Date()
    }

    override func tearDownWithError() throws {
        
    }

    func test_defaultConstructor_generatesId() throws {
        XCTAssertEqual(item.getId().uuidString.count, 36)
    }
    
    func test_defaultConstructor_generatesStartDate() throws {
        XCTAssertTrue(item.getStartTime() >= beforeInstanceCreationTime)
        XCTAssertTrue(item.getStartTime() <= afterInstanceCreationTime)
    }
    
    func test_defaultConstructor_generatesNoEndDate() throws {
        XCTAssertEqual(item.getEndTime(), nil)
    }
    
    func test_defaultConstructor_typeIsTBD() throws {
        XCTAssertEqual(item.getType(), TimeLineItemType.TBD)
    }
    
    func test_defaultConstructor_setTime_containsNewEndTime() throws {
        item.setEndTimeNow(type: TimeLineItemType.WORK)
        XCTAssertNotNil(item.getEndTime())
        XCTAssertTrue(item.getEndTime()! >= afterInstanceCreationTime)
        XCTAssertTrue(item.getEndTime()! <= Date())
    }

}
