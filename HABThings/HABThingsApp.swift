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

    let menuBarIcon = NSImage(named: NSImage.Name("menubar"))

    var body: some Scene {
        MenuBarExtra {
            ThingsListView(refreshTimerService: refreshTimerService)
                .environmentObject(refreshTimerService)
        } label: {
//            Label("HABThings", systemImage: "gear")
//            Label("HABThings", image: "menubar")
//                .labelStyle(.iconOnly)
            Image(nsImage: menuBarIcon!)
        }
        .menuBarExtraStyle(.window)
    }
}
