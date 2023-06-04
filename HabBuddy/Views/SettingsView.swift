//
//  SettingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import SwiftUI

struct SettingsView: View {
    private var keyChainManager = KeychainManager()
    @Environment(\.presentationMode) var presentationMode

    @State private var urlString: String = ""
    @State private var apiToken: String = ""

    var body: some View {
        VStack {
            Text("Hallo")
            Image(systemName: "circle")
                .frame(width: 100, height: 100)
            Text("URL: \(urlString)")
            Text("Key: \(apiToken)")
            TextField("URL", text: $urlString)
            TextField("Token", text: $apiToken)
//            Button("Save") {
//                Task {
//                    keyChainManager.saveKeys(urlString: urlString, apiToken: apiToken)
//                    presentationMode.wrappedValue.dismiss()
//                }
//            }
        }
        .navigationTitle("Settings")
        .task {
            let credentials = keyChainManager.getKeys()
            urlString = credentials.urlString
            apiToken = credentials.apiToken
            print("SETTINGSVIEW APPAERED")
        }
        .onDisappear {
            print("SETTINGSVIEW DISAPPAERED")
            shouldRefresh.toggle()
            Task {
                keyChainManager.saveKeys(urlString: urlString, apiToken: apiToken)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
