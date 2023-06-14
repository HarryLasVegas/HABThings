//
//  RequestGenerator.swift
//  HabBuddy
//
//  Created by Stephan Weber on 13.06.23.
//

import Foundation

class RequestGenerator {
    static let shared = RequestGenerator()
    private init() {}

    @MainActor func generatedRequest(apiEndpoint: APIEndpoint) throws -> URLRequest {
        let credentials = KeyChainManager.shared.getCredentialsFromKeychain()
        let urlString = credentials.urlString
        let apiToken = credentials.apiToken
        let eMail = credentials.eMail
        let password = credentials.password

        let selectedServerType: ServerType = ServerType(
            rawValue: UserDefaults.standard.string(forKey: "selectedServerType")!
        ) ?? .local
        // TODO: Here

        guard !urlString.isEmpty else { throw APIError.emptyURL}
        guard !apiToken.isEmpty else { throw APIError.emptyAPItoken}

        let completeURL = "\(urlString)/rest/\(apiEndpoint.endPointString)"

        guard
            let requestURL = URL(string: completeURL)
        else {
            throw APIError.invalidURL
        }

        let authorizationKey = "Bearer \(apiToken)"

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")

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
            return "Self hosted openHAB cloud service"
        }
    }

    // TODO: Help Texts
    //    Text(verbatim: "Please enter the network address(URL) of your openHAB server
    // (including the port). It usually looks someting like this: \n'http://192.168.1.78:8080'.")
    //    Text("Please also enter an API-Token. You can generate a new one in the admin area of openHAB.
    // If you need help, here are the offical instructions: https://www.openhab.org/docs/configuration/apitokens.html")
    var helpText: String {
        switch self {
        case .local:
            return "local helptext"
        case .myOpenHAB:
            return "myopenHab helptext"
        case .otherCloudInstance:
            return "own helptext"
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
