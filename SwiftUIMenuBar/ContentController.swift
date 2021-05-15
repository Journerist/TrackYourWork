//
//  ContentController.swift
//  SwiftUIMenuBar
//
//  Created by Barthel, Sebastian on 15.05.21.
//  Copyright © 2021 Aaron Wright. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]

}
