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
            ContentView()
                .environmentObject(settingsManager)
                .environmentObject(refreshTimerService)
        } label: {
//            Label("habBuddy", systemImage: "note.text")
            Label("HABbuddy", image: "menubar")
                .labelStyle(.iconOnly)
        }
        .menuBarExtraStyle(.window)
    }
}
