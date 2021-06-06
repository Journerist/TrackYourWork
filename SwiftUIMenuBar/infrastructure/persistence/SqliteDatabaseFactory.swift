//
//  SqliteDatabaseFactory.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 21.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

struct SqliteDatabaseFactory {
    
    func create() throws -> SqliteDatabase{
        let db = try SqliteDatabase(dbName: "production")
        try db.setupDatabase()
        
        return db
    }

}
