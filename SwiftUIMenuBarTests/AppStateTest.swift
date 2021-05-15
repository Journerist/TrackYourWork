//
//  AppStateTest.swift
//  SwiftUIMenuBarTests
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

@testable import SwiftUIMenuBar
import XCTest

class AppStateTest: XCTestCase {

    var appState: AppState!
    
    override func setUp() {
        super.setUp()
        appState = AppState()
    }
    
    func test_initial_counter_is_zero() {
        XCTAssertEqual(appState.mouseMoveCounter, 0)
    }

}
