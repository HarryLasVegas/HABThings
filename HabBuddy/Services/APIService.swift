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
                             apiEndpoint: APIEndpoint)
                                async throws -> T {

        let completeURL = "\(urlString)/rest/\(apiEndpoint.endPointString)"

        guard
            let url = URL(string: completeURL)
        else {
            throw APIError.invalidURL
        }

        do {
            let authorizationKey: String = "Bearer \(apiToken)"

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
            else {
                // TODO: alle Responsecodes abfangen 401 ist der token
                throw APIError.invalidResponseStatus
            }
            print(httpResponse.statusCode)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.dataDecodingStrategy = dataDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case dataTaskError(String) // URLSession didn't work
    case invalidResponseStatus
    case decodingError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The provided URL is not valid", comment: "")
        case .dataTaskError(let string):
            return string + " Please check Settings for the right URL."  // the assocated value
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response", comment: "")
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
