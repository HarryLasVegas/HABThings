//
//  KeychainManager.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import KeychainAccess

class KeyChainManager {
    static let shared = KeyChainManager()

    private let keyChain = Keychain(service: "de.stephanweber.HabBuddy")


    private init() {}

    /// Gets the values for urlString, apiToken, userName and password
    /// stored in the Keychain and  returns them.
    /// If a key is not present, the corresponding variable is set to an empty String
    // swiftlint:disable:netxt large_tuple
    func getCredentialsFromKeychain() -> (urlString: String,
                                          apiToken: String,
                                          userName: String,
                                          password: String) {
        let urlString = keyChain["urlString"] ?? ""
        let apiToken = keyChain["apiToken"] ?? ""
        let userName = keyChain["userName"] ?? ""
        let password = keyChain["password"] ?? ""

        return(urlString, apiToken, userName, password)
    }

    /// Saves the urlString and apiToken to the KeyChain if they contain any String values.
    /// If not, the corresponding Key gets set to nil
    func saveCredentialsToKeychain(urlString: String,
                                   apiToken: String,
                                   userName: String,
                                   password: String) {
        // Empty strings are not written to the KeyChain
        // It would just stay the same as before
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

        if userName.isEmpty {
            keyChain["userName"] = nil
        } else {
            keyChain["userName"] = userName
        }

        if password.isEmpty {
            keyChain["password"] = nil
        } else {
            keyChain["password"] = password
        }
    }
}
