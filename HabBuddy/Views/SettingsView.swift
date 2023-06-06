//
//  SettingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import SwiftUI

struct SettingsView: View {
    // no init needed because no viewModel
    // the settingsManager is passed in by the ".environmentObject" in the APP struct
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.presentationMode) var presentationMode

    @State private var urlString: String = ""
    @State private var apiToken: String = ""

    @State private var updateRegularly = false
    @State private var selectedUpdateInterval = "10s"
    let updateIntervals = ["10s", "30s", "60s"]

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Access data")
                    .font(.headline)
                    .padding(.bottom, 5)

                VStack(alignment: .leading, spacing: 2) {
                    Text("URL to openHAB server")
                        .offset(x: 3)
                    TextField("e.g. http://192.168.1.78:8080", text: $urlString, axis: .vertical)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Api-Token")
                        .offset(x: 3)
                    TextField("API-Token", text: $apiToken, axis: .vertical)
                        .lineLimit(4...5)
                }

                // swiftlint:disable:next line_length
                Text(verbatim: "To access the API of your openHab server we need the network address(URL) of your openHAB server (including the port). It usually looks someting like this: \n'http://192.168.1.78:8080'.")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                // swiftlint:disable:next line_length
                Text("We also need an API-Token to access things. Please generate a new one in the admin area of openHAB. If you need help, here are the offical instructions: https://www.openhab.org/docs/configuration/apitokens.html")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .settingsBoxStyle()

            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Label("Update regularly", systemImage: "timer")
                            .labelStyle(ColorfulIconLabelStyle(color: .purple))
                        Spacer()

                        Toggle("", isOn: $updateRegularly)
                            .toggleStyle(.switch)
                            .labelsHidden()
                    }

                    HStack {
                        Spacer()
                        Text("Update interval")
                            .foregroundColor(updateRegularly ? .primary : .secondary)
                        Picker("", selection: $selectedUpdateInterval) {
                            ForEach(updateIntervals, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 100)
                        .labelsHidden()
                        .disabled(!updateRegularly)
                    }
                }
            }
            .settingsBoxStyle()
        }
        .navigationTitle("Settings")
        .padding(10)
        .task {
            urlString = settingsManager.urlString
            apiToken = settingsManager.apiToken
        }
        .onDisappear {
            settingsManager.objectWillChange.send()
            settingsManager.saveCredentialsToKeychain(urlString: urlString,
                                                      apiToken: apiToken)
            settingsManager.settingsChanged = true
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
