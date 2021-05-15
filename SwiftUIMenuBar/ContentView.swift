//
//  ContentView.swift
//  SwiftUIMenuBar
//
//  Created by Aaron Wright on 12/18/19.
//  Copyright © 2019 Aaron Wright. All rights reserved.
//

import SwiftUI

protocol ContentViewI : View {
    
}

struct ContentView: ContentViewI {
    
    @ObservedObject var appState: AppState
    var mouseMoveInteractor: MouseMoveInteractorI
    
    init(appState: AppState, mouseMoveInteractor: MouseMoveInteractorI) {
        self.appState = appState
        self.mouseMoveInteractor = mouseMoveInteractor
    }
    
    var body: some View {
        Text("Hello, World! Your mouse moved \(appState.mouseMoveCounter) times").onAppear{
                mouseMoveInteractor.watch()
            }
            
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//   }
//}
