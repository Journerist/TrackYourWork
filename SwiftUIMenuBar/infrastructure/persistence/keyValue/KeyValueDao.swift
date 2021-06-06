//
//  KeyValueDao.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 25.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation
import SQLite

class KeyValueDao {
    
    private var db: SqliteDatabase
    
    init(db: SqliteDatabase) {
        self.db = db
    }
    
    func getValue(key: String) -> String? {
        let keyValueTable = Table(Tables.KEY_VALUE_ITEM.rawValue)
        let keyColumn = Expression<String>("key")
        let valueColumn = Expression<String>("value")
        
        let findByIdQuery = keyValueTable.select(keyValueTable[*]).where(keyColumn == key)
    
        
        for item in try! self.db.getConnection().prepare(findByIdQuery) {
            return item[valueColumn]
        }
        
        return nil
    }
    
    func setValue(key: String, value: String) {
        let keyValueTable = Table(Tables.KEY_VALUE_ITEM.rawValue)
        let keyColumn = Expression<String>("key")
        let valueColumn = Expression<String>("value")
        
        let deleteQuery = keyValueTable.where(keyColumn == key)

        
        do {
            try self.db.getConnection().transaction {
                try self.db.getConnection().run(deleteQuery.delete())
                try self.db.getConnection().run(keyValueTable.insert(keyColumn <- key, valueColumn <- value))
            }
        } catch {
            print("Could not execute key value insert query: \(error)")
        }
        
    }
}
