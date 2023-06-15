//
//  SettingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    // no init needed because no viewModel
    // the refreshtimerservice is passed in by the ".environmentObject" in the APP struct
    @EnvironmentObject var refreshTimerService: RefreshTimerService

    @AppStorage("selectedRefreshInterval") var selectedRefreshInterval: RefreshIntervalOptions = .seconds20
    @AppStorage("refreshRegularly") var refreshRegularly: Bool = false
    @AppStorage("selectedServerType") var selectedServerType: ServerType = .local

    @State private var launchOnLogin = SMAppService.mainApp.status == .enabled

    // needed to update the view when returning from SettingsView
    @Binding var shouldRefresh: Bool

    @State private var urlString: String = ""
    @State private var apiToken: String = ""
    @State private var eMail: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            accessDataBox

            refreshBox

            launchOnLoginBox
        }
        .animation(.easeInOut(duration: 0.3), value: selectedServerType)
        .navigationTitle("Settings")
        .padding(10)
        .task {
            getCredentials()
        }
        .onDisappear {
            saveCredentials()
            shouldRefresh.toggle()
        }
    }

    /// Registers and deregisters the app to be started on login of user
    func toggleLaunchOnLogin() {
        do {
            if SMAppService.mainApp.status == .enabled {
                try SMAppService.mainApp.unregister()
            } else {
                try SMAppService.mainApp.register()
            }
        } catch {
            print(error)
        }
    }

    func getCredentials() {
        let credentials = KeyChainManager.shared.getCredentialsFromKeychain()
        urlString = credentials.urlString
        apiToken = credentials.apiToken
        eMail = credentials.eMail
        password = credentials.password
    }

    func saveCredentials() {
        KeyChainManager.shared.saveCredentialsToKeychain(urlString: urlString,
                                                         apiToken: apiToken,
                                                         eMail: eMail,
                                                         password: password)
    }
}

 struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(shouldRefresh: .constant(true))
    }
 }

extension SettingsView {
    private var accessDataBox: some View {
        VStack(alignment: .leading) {
            Label("Access data", systemImage: "person.badge.key")
                .labelStyle(ColorfulIconLabelStyle(color: .blue))
                .padding(.bottom)

            VStack(alignment: .leading, spacing: 5) {
                Text("Type of openHAB server")
                Picker("", selection: $selectedServerType) {
                    ForEach(ServerType.allCases, id: \.self) {
                        Text($0.serverTypeViewString)
                    }
                }
                .pickerStyle(.radioGroup)
            }

            Spacer()
                .frame(height: 30)

            switch selectedServerType {
            case .local, .otherCloudInstance:
                CredentialsTextField(label: "URL to openHAB server",
                                     placeholder: "e.g. http://192.168.1.78:8080",
                                     fieldValue: $urlString)
            default:
                EmptyView()
            }

            switch selectedServerType {
            case .myOpenHAB, .otherCloudInstance:
                CredentialsTextField(label: "E-Mail",
                                     placeholder: "E-Mail",
                                     fieldValue: $eMail)
                CredentialsTextField(label: "Password",
                                     placeholder: "Password",
                                     fieldValue: $password)
            default:
                EmptyView()
            }

            CredentialsTextField(label: "API-Token", placeholder: "API-Token", fieldValue: $apiToken)

            helpTextSegment
        }
        .textFieldStyle(.roundedBorder)
        .settingsBoxStyle()
    }

    private var helpTextSegment: some View {
        Text(LocalizedStringKey(selectedServerType.helpText))
            .foregroundColor(.secondary)
            .font(.subheadline)
            .padding(.bottom)
    }

    private var refreshBox: some View {
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

    private var launchOnLoginBox: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Label("Launch HABbuddy on login", systemImage: "ipad.and.arrow.forward")
                        .labelStyle(ColorfulIconLabelStyle(color: .pink))

                    Spacer()

                    Toggle("", isOn: $launchOnLogin)
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .onChange(of: launchOnLogin) { _ in
                            toggleLaunchOnLogin()
                        }
                }
            }
        }
        .settingsBoxStyle()
    }
}
