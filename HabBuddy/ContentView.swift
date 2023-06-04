//
//  ContentView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsManager: SettingsManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                // EnvironmentObject has to be passed in explicitly because
                // ThingsListView has an initializer
                // The ".environentObject" is useless here
                // The inititializer is needed for the ViewModel
                ThingsListView(settingsManager: settingsManager)
                bottomBar
                    .background(.ultraThickMaterial)
            }
        }
        .frame(minWidth: 350, idealWidth: 350, maxWidth: 350,
               minHeight: 800, idealHeight: 800, maxHeight: 1200,
               alignment: .topLeading)
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
