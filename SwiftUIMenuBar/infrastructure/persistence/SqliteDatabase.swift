//
//  SqliteDatabase.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation
import SQLite

enum Tables: String {
    case TIME_LINE_ITEM = "time_line_item"
    case KEY_VALUE_ITEM = "key_value_item"
}

class SqliteDatabase {
    
    private var connection: Connection
    private var dbName: String
    
    init(dbName: String) throws {
        self.dbName = dbName
        self.connection = try Connection("\(dbName).sqlite3")
    }
    
    func getConnection() -> Connection {
        return connection;
    }
  
    func setupDatabase() throws {
        try setupTimeLineTable()
        try setupKeyValueTable()
    }
    
    private func setupTimeLineTable() throws {
        let timeLineItemTable = Table(Tables.TIME_LINE_ITEM.rawValue)
        let id = Expression<String>("id")
        let startDateTime = Expression<Date>("starDateTime")
        let endDateTime = Expression<Date?>("endDateTime")
        let timeLineItemtype = Expression<String>("type")
        
        if (try tableExists(tableName: Tables.TIME_LINE_ITEM.rawValue)) {
            print("time_line_item table already exists")
        } else {
            print("creating \(Tables.TIME_LINE_ITEM.rawValue) table")
            try connection.run(timeLineItemTable.create { t in
                t.column(id, primaryKey: true)
                t.column(startDateTime)
                t.column(endDateTime)
                t.column(timeLineItemtype)
            })
            
            try connection.run(timeLineItemTable.createIndex(timeLineItemtype))
        }
    }
    
    private func setupKeyValueTable() throws {
        let keyValueTable = Table(Tables.KEY_VALUE_ITEM.rawValue)
        let key = Expression<String>("key")
        let value = Expression<String>("value")
        
        if (try tableExists(tableName: Tables.KEY_VALUE_ITEM.rawValue)) {
            print("\(Tables.KEY_VALUE_ITEM.rawValue) table already exists")
        } else {
            print("creating \(Tables.KEY_VALUE_ITEM.rawValue) table")
            try connection.run(keyValueTable.create { t in
                t.column(key, primaryKey: true)
                t.column(value)
            })
        }
    }
    
    func tableExists(tableName: String) throws -> Bool {
        let masterTable = Table("sqlite_master")
        let name = Expression<String>("name")
        let type = Expression<String>("type")

        
        let existingtTimeLineItemTableCount = try self.connection.scalar(masterTable
                                        .filter(type == "table")
                                        .filter(name == tableName)
                                        .count)

        return existingtTimeLineItemTableCount > 0
    }
    
    func existsOnDevice() -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "./\(dbName).sqlite3") {
            return true
        } else {
            return false
        }
    }
    
    func delete() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: "./\(dbName).sqlite3")
        } catch {
            print("Could not delete \(dbName): \(error)")
        }
    }
}
