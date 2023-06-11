//
//  APIService.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation

struct APIService {
    let urlString: String
    let apiToken: String

    func getJSON<T: Codable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                             keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                             dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
                             apiEndpoint: APIEndpoint,
                             server: ServerType)
                                async throws -> T {

        do {

//            curl -X 'GET' \
//              'https://Mydomain.de/rest/things' \
//            --user  'myname@maildomain.de:MyPassword' \
//              -H 'accept: application/json' \
//              -H 'X-OPENHAB-TOKEN: oh.testdeletelater.ABwhfj5x5BT1i7QKzIhgRoxVXYZilzMaX0qDtueVox6W6W2fA06gGwJhDZePDQMQytVkAoobst9ndWiztmmg'




            guard !urlString.isEmpty else { throw APIError.emptyURL }
            guard !apiToken.isEmpty else { throw APIError.emptyAPItoken }

            let completeURL = "\(urlString)/rest/\(apiEndpoint.endPointString)"

            guard
                let requestURL = URL(string: completeURL)
            else {
                throw APIError.invalidURL
            }

            let authorizationKey: String = "Bearer \(apiToken)"

            var request = URLRequest(url: requestURL)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")

            guard
                let (data, response) = try? await URLSession.shared.data(for: request)
            else {
                throw APIError.couldntConnect
            }
            guard
                let httpResponse = response as? HTTPURLResponse
            else {
                throw APIError.invalidResponseStatus
            }

            guard httpResponse.statusCode == 200
            else {
                if httpResponse.statusCode == 401 {
                    throw APIError.unauthorized
                } else {
                    throw APIError.invalidResponseStatus
                }
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.dataDecodingStrategy = dataDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                print("decoding error")
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }
}

enum APIError: Error, LocalizedError {
    case emptyURL
    case emptyAPItoken
    case invalidURL
    case dataTaskError(String) // takes the error thrown in the do block
    case couldntConnect
    case unauthorized
    case invalidResponseStatus
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .emptyURL:
            return NSLocalizedString("Please enter a URL in settings", comment: "")
        case .emptyAPItoken:
            return NSLocalizedString("Please enter an API-Token in settings", comment: "")
        case .invalidURL:
            return NSLocalizedString("The provided URL is not valid", comment: "")
        case .dataTaskError(let string):
            return string // the associated value
        case .couldntConnect:
            return NSLocalizedString("Couldn't connect to server. Please check the URL in settings.", comment: "")
        case .unauthorized:
            return NSLocalizedString("Server responded unauthorized access. Please check your API-Token.", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response.", comment: "")
        case .decodingError(let string):
            return string

        }
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

enum ServerType {
    case local(url: String, apiToken: String)
    case myOpenHAB(user: String, password: String, apiToken: String)
    case otherCloudInstance(url: String, user: String, password: String, apiToken: String)

    var request: URLRequest {
        switch self {
        case .local:
            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
        case .myOpenHAB:
            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
        case .otherCloudInstance:
            return URLRequest(url: URL(string: "http://www.groundshots.de")! )
        }
    }
}
