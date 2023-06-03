//
//  HabBuddyApp.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI

@main
struct HabBuddyApp: App {
    var body: some Scene {
        MenuBarExtra {
            ContentView()
        } label: {
            Label("habBuddy", systemImage: "note.text")
                .labelStyle(.titleAndIcon)
        }
        .menuBarExtraStyle(.window)
    }
}
