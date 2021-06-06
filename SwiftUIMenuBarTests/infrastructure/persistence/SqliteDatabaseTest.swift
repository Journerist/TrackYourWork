//
//  SqliteDatabaseTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 21.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import XCTest
@testable import SwiftUIMenuBar

class SqliteDatabaseTest: XCTestCase {

    private var db: SqliteDatabase!
    
    override func setUpWithError() throws {
        db = try SqliteDatabase(dbName: "test_db")
    }

    override func tearDownWithError() throws {
        try db.delete()
    }
    
    func test_databaseExists_afterDelete_isDeleted() throws {
        let db = try SqliteDatabase(dbName: "test_db_test_delete")
        XCTAssertEqual(db.existsOnDevice(), true)
        try db.delete()
        XCTAssertEqual(db.existsOnDevice(), false)
    }
    
    func test_afterInit_tablesDoNotExist() throws {
        let tableExist = try db.tableExists(tableName: Tables.TIME_LINE_ITEM.rawValue)
        XCTAssertEqual(tableExist, false)
    }
    
    func test_afterSetup_tablesExists() throws {
        try db.setupDatabase()
        let tableExist = try db.tableExists(tableName: Tables.TIME_LINE_ITEM.rawValue)
        XCTAssertEqual(tableExist, true)
    }

}
