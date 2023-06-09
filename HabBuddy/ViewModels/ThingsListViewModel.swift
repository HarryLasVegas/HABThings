//
//  ThingsViewModel.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation
import SwiftUI

class ThingsListViewModel: ObservableObject {
    @AppStorage("refreshRegularly") var refreshRegularly: Bool?
    @Published var things: [Thing] = []

    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?

    @Published var lastFetchFailed: Bool?
    @Published var searchText = ""

    private var settingsManager: SettingsManager
    private var refreshTimerService: RefreshTimerService

    init(settingsManager: SettingsManager, refreshTimerService: RefreshTimerService) {
        self.settingsManager = settingsManager
        self.refreshTimerService = refreshTimerService
    }

    // if the code of the function is exectued in init, the observer is added twice
    // so it's added to the "task" of ThingsListView
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(timerFired),
                                               name: NSNotification.Name("TimerFired"),
                                               object: nil)
    }

    @MainActor
    func fetchThings() async {
        fetchCredentials()

        let apiService = APIService(urlString: settingsManager.urlString, apiToken: settingsManager.apiToken)
        Task {
            withAnimation {
                isLoading.toggle()
            }
        }

        defer {
            Task {
                withAnimation {
                    isLoading.toggle()
                }
            }
        }

        do {
            things = try await apiService.getJSON(apiEndpoint: .things)
            things.sort { $0.viewLabel < $1.viewLabel }
                lastFetchFailed = false
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
            things = []
                lastFetchFailed = true
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

    @objc private func timerFired() {
        Task {
            await fetchThings()
        }
    }
}
