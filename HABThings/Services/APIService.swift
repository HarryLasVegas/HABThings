//
//  APIService.swift
//  HABThings
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation

class APIService {
    static let shared = APIService()

    private init() {}

    func getJSON<T: Codable> (apiEndpoint: APIEndpoint) async throws -> T {
        let demoModeIsActivated = UserDefaults.standard.bool(forKey: "demoModeIsActive")

        // if demo mode is activated, DemoData.json is decoded and returned
        // if not, a server connection is established
        if !demoModeIsActivated {
            return try await getJSONfromServer(apiEndpoint: apiEndpoint)
        } else {
            return Bundle.main.decode(Constants.demoDataPath)
        }
    }

    private func getJSONfromServer<T: Codable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                               dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
                                               apiEndpoint: APIEndpoint)
                                async throws -> T {

        do {
            let request = try await RequestGenerator.shared.generatedRequest(apiEndpoint: apiEndpoint)

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
            // takes any error thrown in the above
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
            return string
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
