//
//  ThingsViewModel.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation

class ThingsListViewModel: ObservableObject {
    @Published var things: [Thing] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?

    private var keychainManager = KeychainManager()

    var urlString: String = ""
    var apiToken: String = ""

//    let urlString: String = "http://192.168.178.45:8080/rest/things"
//    let apiToken: String = "oh.habBuddyToken.LlvKRbWd6AgGjdxH2mbU1VyMFpksF7Wwlin8qjDpCCa9Vuoi2AQKyz9VLyw6XcheKZOLUQvnO3U2zvqmw"

    @MainActor
    func fetchThings() async {
        let apiService = APIService(urlString: urlString, apiToken: apiToken)
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            things = try await apiService.getJSON()
            things.sort { $0.viewLabel < $1.viewLabel }
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchCredentials() {
        let credentials = keychainManager.getKeys()
        urlString = credentials.urlString
        apiToken = credentials.apiToken
    }

    // checks if there are things withe the given status
    func thingsWithStatusPresent(for status: String) -> Bool {
        if things.filter({ $0.viewStatus.lowercased() == status.lowercased() }).count > 0 {
            return true
        } else {
            return false
        }
    }

    var amountOfThings: Int {
        return things.count
    }

//    var offlineThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "offline" }
//    }
//
//    var onlineThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "online" }
//    }
//
//    var uninitializedThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "uninitialized" }
//    }
//
//    var initializingThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "initializing" }
//    }
//
//    var removedThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "removed" }
//    }
//
//    var removingThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "removing" }
//    }
//
//    var unknownThings: [Thing] {
//        return things.filter { $0.viewStatus.lowercased() == "unknown" }
//    }
}
