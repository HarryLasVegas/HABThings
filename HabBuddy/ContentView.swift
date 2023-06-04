//
//  ContentView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                ThingsListView()
                bottomBar
                    .background(.ultraThickMaterial)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private var bottomBar: some View {
        HStack(spacing: 0) {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gear")
            }
            .buttonStyle(.borderless)
            .controlSize(.large)
            .focusable(false)
            .help("Settings")

            Spacer()

            Button {
                NSApp.terminate(nil)
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .buttonStyle(.borderless)
            .controlSize(.regular)
            .focusable(false)
            .help("Quit")
        }
        .padding(10)

    }
}
