//
//  KeychainManager.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import KeychainAccess

class SettingsManager: ObservableObject {
    private let keyChain = Keychain(service: "de.stephanweber.HabBuddy")

    @Published private(set) var urlString: String = ""
    @Published private(set) var apiToken: String = ""

    @Published var settingsChanged: Bool = false

    init() {
        getCredentialsFromKeychain()
//        self.urlString = credentials.urlString
//        self.apiToken = credentials.apiToken
    }

    func getCredentialsFromKeychain() {
        urlString = keyChain["urlString"] ?? ""
        apiToken = keyChain["apiToken"] ?? ""

    }

    func saveCredentialsToKeychain(urlString: String, apiToken: String) {
        keyChain["urlString"] = urlString
        keyChain["apiToken"] =  apiToken
    }
}
