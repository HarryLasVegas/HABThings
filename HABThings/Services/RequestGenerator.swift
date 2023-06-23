//
//  RequestGenerator.swift
//  HABThings
//
//  Created by Stephan Weber on 13.06.23.
//

import Foundation

class RequestGenerator {
    static let shared = RequestGenerator()
    private init() {}

    // swiftlint:disable:next function_body_length
    @MainActor func generatedRequest(apiEndpoint: APIEndpoint) throws -> URLRequest {
        let selectedServerType: ServerType = ServerType(
            rawValue: UserDefaults.standard.string(forKey: "selectedServerType") ?? ""
        ) ?? .local

        let credentials = KeyChainManager.shared.getCredentialsFromKeychain()
        let apiToken = credentials.apiToken
        let eMail = credentials.eMail
        let password = credentials.password
        var urlString: String

        if selectedServerType == .myOpenHAB {
            urlString = Constants.myOpenHABURL
        } else {
            urlString = credentials.urlString
        }

        // urlString and token are both needed in all cases
        guard !urlString.isEmpty else { throw APIError.emptyURL}
        guard !apiToken.isEmpty else { throw APIError.emptyAPItoken}

        // completeURLString is different for every ServerType
        var completeURLString: String
        switch selectedServerType {
        case .local:
            completeURLString = urlString + Constants.URLPathComplement + apiEndpoint.endPointString
        case .myOpenHAB:
            completeURLString = Constants.myOpenHABURL + Constants.URLPathComplement + apiEndpoint.endPointString
        case .otherCloudInstance:
            completeURLString = urlString + Constants.URLPathComplement + apiEndpoint.endPointString
        }

        // Generate the URL for the request
        guard
            let requestURL = URL(string: completeURLString)
        else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")

        // additional headers for request depending on ServerType
        switch selectedServerType {
        case .local:
            let authorizationKey = selectedServerType.authorizationComplement + apiToken
            request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")

        case .myOpenHAB, .otherCloudInstance:
            let loginString = String(format: "%@:%@", eMail, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()

            let authorizationKey = selectedServerType.authorizationComplement + base64LoginString

            request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
            request.setValue(apiToken, forHTTPHeaderField: "X-OPENHAB-TOKEN")
        }
        // TODO: Check if working with other cloud instances
        return request
        }
}

enum APIEndpoint {
    case things
    case items

    var endPointString: String {
        switch self {
        case .things:
            return "things"
        case .items:
            return "items"
        }
    }
}

enum ServerType: String, CaseIterable {
    case local
    case myOpenHAB
    case otherCloudInstance

    var serverTypeViewString: String {
        switch self {
        case .local:
            return "Local"
        case .myOpenHAB:
            return "OpenHAB Cloud (myopenhab.org)"
        case .otherCloudInstance:
            return "Self hosted openHAB cloud service (experimental)"
        }
    }

    var authorizationComplement: String {
        switch self {
        case .local:
            return "Bearer "
        case .myOpenHAB, .otherCloudInstance:
            return "Basic "
        }
    }

    var helpText: String {
        let localString = """
            Please enter the network address (URL) of your openHAB server \
            (including the port). It usually looks someting like this:\'http://192.168.1.78:8080\'.

            Please also enter an API-Token. You can generate a new one in \
            the admin area of openHAB. If you need help, here are the offical \
            instructions: https://www.openhab.org/docs/configuration/apitokens.html
            """

        let myOpenHABString = """
            Please enter the E-Mail and Password for your myOpenHAB.org account.

            Please also enter an API-Token. You can generate a new one in \
            the admin area of openHAB. If you need help, here are the offical \
            instructions: https://www.openhab.org/docs/configuration/apitokens.html
            """

        let otherCloudInstanceString = """
            Please enter the URL of your openHAB server \
            and the E-Mail and Password for your user.

            Please also enter an API-Token. You can generate a new one in \
            the admin area of openHAB. If you need help, here are the offical \
            instructions: https://www.openhab.org/docs/configuration/apitokens.html
            """

        switch self {
        case .local:
            return localString
        case .myOpenHAB:
            return myOpenHABString
        case .otherCloudInstance:
            return otherCloudInstanceString
        }
    }

//    var request: URLRequest {
//        switch self {
//        case .local:
//            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
//        case .myOpenHAB:
//            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
//        case .otherCloudInstance:
//            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
//        }
    }
