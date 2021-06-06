//
//  KeyValueDaoTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 25.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class KeyValueDaoTest: XCTestCase {

    private var keyValueDao: KeyValueDao!
    private var db: SqliteDatabase!

    override func setUpWithError() throws {
        db = try SqliteDatabase(dbName: "ScreenTimeRepositoryTest")
        try db.setupDatabase()
        keyValueDao = KeyValueDao(db: self.db)
    }

    override func tearDownWithError() throws {
        db.delete()
    }

    func test_noValues_returnsNil() throws {
        let result = keyValueDao.getValue(key: "key")
        XCTAssertEqual(result, nil)
    }
    
    func test_containsValue_returnsValue() throws {
        keyValueDao.setValue(key: "key", value: "value")
        let result = keyValueDao.getValue(key: "key")
        XCTAssertEqual(result, "value")
    }
    
    func test_containsValue_overridesValue_returnsValue() throws {
        keyValueDao.setValue(key: "key", value: "value")
        keyValueDao.setValue(key: "key", value: "value2")
        let result = keyValueDao.getValue(key: "key")
        XCTAssertEqual(result, "value2")
    }

}
