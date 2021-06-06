//
//  ScreenTimeRepository.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 23.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import Foundation

class ScreenTimeRepository {
    
    private var keyValueDao: KeyValueDao
    
    init(keyValueDao: KeyValueDao) {
        self.keyValueDao = keyValueDao
    }
    
    func save(screenTime: ScreenTime) {
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(screenTime)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            keyValueDao.setValue(key: "screenTime", value: json!)
        } catch {
            print("Error while storing screen time: \(error)")
        }

    }
    
    func getCurrent() -> ScreenTime? {
        let json = keyValueDao.getValue(key: "screenTime")
        
        if (json == nil) {
            return nil
        }

        let jsonDecoder = JSONDecoder()
        do {
            let screenTime = try jsonDecoder.decode(ScreenTime.self, from: json!.data(using: String.Encoding.utf8)!)
            return screenTime
        } catch {
            print("Error getting current screen time: \(error)")
        }
        
        return nil
    }
    
}
