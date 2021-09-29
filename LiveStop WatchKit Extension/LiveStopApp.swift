//
//  LiveStopApp.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import SwiftUI

@main
struct LiveStopApp: App {
    @StateObject var modelData = ModelData.shared
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environmentObject(modelData)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
