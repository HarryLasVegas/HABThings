//
//  SettingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import SwiftUI

//enum RefreshIntervalOptions: Int, CaseIterable {
//    case seconds10 = 10
//    case seconds20 = 20
//    case seconds60 = 60
//    case minutes5 = 300
//
//    var stringValue: String {
//            switch self {
//            case .seconds10: return "10s"
//            case .seconds20: return "20s"
//            case .seconds60: return "60s"
//            case .minutes5: return "5min"
//            }
//    }
//}

struct SettingsView: View {
    // no init needed because no viewModel
    // the settingsManager is passed in by the ".environmentObject" in the APP struct
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var refreshTimerService: RefreshTimerService
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("selectedRefreshInterval") var selectedRefreshInterval: RefreshIntervalOptions = .seconds20
    @AppStorage("refreshRegularly") var refreshRegularly: Bool = false

    @State private var urlString: String = ""
    @State private var apiToken: String = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Label("Access data", systemImage: "person.badge.key")
                    .labelStyle(ColorfulIconLabelStyle(color: .blue))
                    .padding(.bottom)

                VStack(alignment: .leading, spacing: 2) {
                    Text("URL to openHAB server:")
                        .offset(x: 3)
                    TextField("e.g. http://192.168.1.78:8080", text: $urlString, axis: .vertical)
                }
                .padding(.bottom)

                VStack(alignment: .leading, spacing: 2) {
                    Text("API-Token:")
                        .offset(x: 3)
                    TextField("API-Token", text: $apiToken, axis: .vertical)
                        .lineLimit(4...5)
                }

                // swiftlint:disable line_length
                Group {
                    Text(verbatim: "Please enter the network address(URL) of your openHAB server (including the port). It usually looks someting like this: \n'http://192.168.1.78:8080'.")

                    Text("Please also enter an API-Token. You can generate a new one in the admin area of openHAB. If you need help, here are the offical instructions: https://www.openhab.org/docs/configuration/apitokens.html")
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
                .padding(.bottom)
                // swiftlint:enable line_length
            }
            .settingsBoxStyle()

            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        Label("Refresh regularly", systemImage: "timer")
                            .labelStyle(ColorfulIconLabelStyle(color: .purple))

                        Spacer()

                        Toggle("", isOn: $refreshRegularly)
                            .toggleStyle(.switch)
                            .labelsHidden()
                            .onChange(of: refreshRegularly) { refreshRegularly in
                                if refreshRegularly == true {
                                    refreshTimerService.resetTimer()
                                } else {
                                    refreshTimerService.stopRefreshTimer()
                                }
                            }
                    }

                    HStack {
                        Spacer()
                        Text("Refresh interval")
                            .foregroundColor(refreshRegularly ? .primary : .secondary)
                        Picker("", selection: $selectedRefreshInterval) {
                            ForEach(RefreshIntervalOptions.allCases, id: \.self) {
                                Text($0.stringValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: 100)
                        .labelsHidden()
                        .disabled(!refreshRegularly)
                        .onChange(of: selectedRefreshInterval) { _ in
                            refreshTimerService.resetTimer()
                        }
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
