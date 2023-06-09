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
    }

    /// Gets the values for urlString and apiToken stored in the Keychain and
    /// assigns them to the corresponding variables.
    /// If a key is not present, the corresponding variable is set to an empty String
    func getCredentialsFromKeychain() {
        urlString = keyChain["urlString"] ?? ""
        apiToken = keyChain["apiToken"] ?? ""
    }

    /// Saves the urlString and apiToken to the KeyChain if they contain any String values.
    /// If not, the corresponding Key gets set to nil
    func saveCredentialsToKeychain(urlString: String, apiToken: String) {
        // Empty strings are not written to the KeyChain
        // so if the given urlString or apiToken are empty
        // the keys are set to nil
        if urlString.isEmpty {
            keyChain["urlString"] = nil
        } else {
            keyChain["urlString"] = urlString
        }

        if apiToken.isEmpty {
            keyChain["apiToken"] = nil
        } else {
            keyChain["apiToken"] = apiToken
        }
    }
}
