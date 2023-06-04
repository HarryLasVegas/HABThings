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
//    @StateObject var keyChainManager = KeychainManager()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
//                .environmentObject(keyChainManager)
        } label: {
            Label("habBuddy", systemImage: "note.text")
                .labelStyle(.titleAndIcon)
        }
        .menuBarExtraStyle(.window)
    }
}
