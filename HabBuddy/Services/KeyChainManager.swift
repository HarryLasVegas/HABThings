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

    /// Gets the values for urlString, apiToken, eMail and password
    /// stored in the Keychain and  returns them.
    /// If a key is not present, the corresponding variable is set to an empty String
    // swiftlint:disable:netxt large_tuple
    func getCredentialsFromKeychain() -> (urlString: String,
                                          apiToken: String,
                                          eMail: String,
                                          password: String) {
        let urlString = keyChain["urlString"] ?? ""
        let apiToken = keyChain["apiToken"] ?? ""
        let eMail = keyChain["eMail"] ?? ""
        let password = keyChain["password"] ?? ""

        return(urlString, apiToken, eMail, password)
    }

    /// Saves the urlString, apiToken, eMail and password to the KeyChain
    /// if they contain any String values.
    /// If not, the corresponding Key gets set to nil
    func saveCredentialsToKeychain(urlString: String,
                                   apiToken: String,
                                   eMail: String,
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

        if eMail.isEmpty {
            keyChain["eMail"] = nil
        } else {
            keyChain["eMail"] = eMail
        }

        if password.isEmpty {
            keyChain["password"] = nil
        } else {
            keyChain["password"] = password
        }
    }
}
