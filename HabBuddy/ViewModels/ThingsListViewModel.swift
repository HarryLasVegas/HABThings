//
//  ThingsViewModel.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation
import SwiftUI

class ThingsListViewModel: ObservableObject {

    @Published var things: [Thing] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    @Published var showingErrorBanner = false
    @Published var searchText = ""

    var settingsManager: SettingsManager

    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
    }

    @MainActor
    func fetchThings() async {
        fetchCredentials()

        let apiService = APIService(urlString: settingsManager.urlString, apiToken: settingsManager.apiToken)
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        do {
            things = try await apiService.getJSON()
            things.sort { $0.viewLabel < $1.viewLabel }
            withAnimation {
                showingErrorBanner = false
            }
        } catch {
            showAlert = true
            print("ERROR: \(error)")
            errorMessage = error.localizedDescription
            things = []
            withAnimation {
                showingErrorBanner = true
            }
        }
    }

    func fetchCredentials() {
        settingsManager.getCredentialsFromKeychain()
    }

    // checks if there are things with the given status - the searchfilter is regarded!
    func thingsWithStatusPresent(for status: String) -> Bool {
        if filteredThings.filter({ $0.viewStatus.lowercased() == status.lowercased() }).count > 0 {
            return true
        } else {
            return false
        }
    }

    var amountOfThings: Int {
        return things.count
    }

    var filteredThings: [Thing] {
        if searchText.isEmpty {
            return things
        } else {
            return things.filter({ $0.viewLabel.localizedCaseInsensitiveContains(searchText)})
        }
    }
}
