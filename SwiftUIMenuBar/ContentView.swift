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
        Button("Stop current session") {
            mouseMoveInteractor.stopCurrentSessionAndCloseApp()
        }
        Text("Current working time: \(appState.workingTime)").onAppear{
                mouseMoveInteractor.watch()
            }
        Text("Working time left: \(appState.workingTimeLeft)")
            
            
        .frame(height: 100)
        
        ScrollView (.horizontal, showsIndicators: false) {
            
            ForEach(appState.unknownClosedSessions) { session in
                HStack {
                    Text(formatDate(date: session.getStart()))
                    Text(" - ")
                    Text(formatDate(date: session.getEnd()))
                    Button("W") {
                        mouseMoveInteractor.setSessionType(sessionStartTime: session.getStart(), type: ScreenTimeType.WORKING)
                    }
                    
                    Button("P") {
                        mouseMoveInteractor.setSessionType(sessionStartTime: session.getStart(), type: ScreenTimeType.PAUSE)
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    func formatDate(date: Date?) -> String {
        
        if (date == nil) {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")

        let datetime = formatter.string(from: date!)
        return datetime
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//   }
//}
