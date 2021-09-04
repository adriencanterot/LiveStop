//
//  LiveStopApp.swift
//  LiveStop WatchKit Extension
//
//  Created by Adrien Cantérot on 04/09/2021.
//

import SwiftUI

@main
struct LiveStopApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
