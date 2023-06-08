//
//  HabBuddyApp.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI
import KeychainAccess

@main
struct HabBuddyApp: App {
    @StateObject var settingsManager = SettingsManager()
    @StateObject var refreshTimerService = RefreshTimerService()

    var body: some Scene {
        MenuBarExtra {
//            ContentView()
            ThingsListView(settingsManager: settingsManager,
                           refreshTimerService: refreshTimerService)
                .environmentObject(settingsManager)
                .environmentObject(refreshTimerService)
        } label: {
            Label("HABbuddy", image: "menubar")
                .labelStyle(.iconOnly)
        }
        .menuBarExtraStyle(.window)
    }
}
