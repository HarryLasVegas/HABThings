//
//  HABThingsApp.swift
//  HABThings
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI
import KeychainAccess

@main
struct HABThingsApp: App {
    @StateObject var refreshTimerService = RefreshTimerService()

    var body: some Scene {
        MenuBarExtra {
//            ContentView()
            ThingsListView(refreshTimerService: refreshTimerService)
                .environmentObject(refreshTimerService)
        } label: {
            Label("HABThings", image: "menubar")
                .labelStyle(.iconOnly)
        }
        .menuBarExtraStyle(.window)
    }
}
