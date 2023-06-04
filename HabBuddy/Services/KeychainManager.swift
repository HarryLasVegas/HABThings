//
//  KeychainManager.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import KeychainAccess

class KeychainManager {
    private let keyChain = Keychain(service: "de.stephanweber.HabBuddy")

    func getKeys() -> (urlString: String, apiToken: String) {
        let loadedURL = keyChain["urlString"] ?? ""
        let loadedToken = keyChain["apiToken"] ?? ""

        return (loadedURL, loadedToken)
    }

    func saveKeys(urlString: String, apiToken: String) {
        keyChain["urlString"] = urlString
        keyChain["apiToken"] =  apiToken
    }
}
