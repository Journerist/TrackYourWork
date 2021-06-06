//
//  ScreenTimeRepositoryTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 23.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class ScreenTimeRepositoryTest: XCTestCase {

    private var screenTimeRepository: ScreenTimeRepository!
    private var db: SqliteDatabase!

    override func setUpWithError() throws {
        db = try SqliteDatabase(dbName: "ScreenTimeRepositoryTest")
        try db.setupDatabase()
        
        let keyValueDao = KeyValueDao(db: db)
        screenTimeRepository = ScreenTimeRepository(keyValueDao: keyValueDao)
    }

    override func tearDownWithError() throws {
        db.delete()
    }
    
    func test_nothingStored_ReturnsNil() throws {
        let foundScreenTime = screenTimeRepository.getCurrent()
        
        XCTAssertEqual(foundScreenTime, nil)
    }
    

    func test_storeScreenTime_getScreenTime_shouldEqualAfterwards() throws {
        let screenTime = ScreenTime()
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        screenTimeRepository.save(screenTime: screenTime)
        
        let foundScreenTime = screenTimeRepository.getCurrent()
        
        XCTAssertEqual(screenTime, foundScreenTime)
    }
    
    func test_storeScreenTime_onlyOneStarted_shouldNotBeEqual() throws {
        let screenTime = ScreenTime()
        screenTimeRepository.save(screenTime: screenTime)

        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        let foundScreenTime = screenTimeRepository.getCurrent()
        
        XCTAssertNotEqual(screenTime, foundScreenTime)
    }
    
    func test_screenTimeWithAllFields_afterStore_shouldBeEqual() throws {
        let screenTime = ScreenTime()
        
        // full session
        screenTime.startSession(type: ScreenTimeType.WORKING)
        screenTime.endSession()
        
        // not ended session
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        // running session
        screenTime.startSession(type: ScreenTimeType.WORKING)
        
        screenTimeRepository.save(screenTime: screenTime)
        
        let foundScreenTime = screenTimeRepository.getCurrent()
        
        XCTAssertEqual(screenTime, foundScreenTime)
    }

}
