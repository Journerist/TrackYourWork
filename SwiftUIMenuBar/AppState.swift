//
//  AppState.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import SwiftUI

protocol AppStateI {
    var mouseMoveCounter: Int {get}
    func incrementMouseCounter()
}

class AppState: ObservableObject, AppStateI {
    var mouseMoveCounter: Int = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    func incrementMouseCounter() {
        mouseMoveCounter += 1
    }
}
