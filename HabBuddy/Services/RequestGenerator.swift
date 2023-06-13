//
//  RequestGenerator.swift
//  HabBuddy
//
//  Created by Stephan Weber on 13.06.23.
//

import Foundation

class RequestGenerator {
    static let shared = RequestGenerator()

    let apiEndpoint: APIEndpoint = .things

    private init() {}

    @MainActor func generatedRequest() throws -> URLRequest {
        let credentials = KeyChainManager.shared.getCredentialsFromKeychain()

        let urlString = credentials.urlString
        let apiToken = credentials.apiToken
        let userName = credentials.userName
        let password = credentials.password

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

enum ServerType {
    case local(url: String, apiToken: String)
    case myOpenHAB(user: String, password: String, apiToken: String)
    case otherCloudInstance(url: String, user: String, password: String, apiToken: String)

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
}
