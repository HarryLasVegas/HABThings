//
//  RefreshTimerService.swift
//  HabBuddy
//
//  Created by Stephan Weber on 07.06.23.
//

import Foundation

enum RefreshIntervalOptions: Int, CaseIterable {
    case seconds2 = 2
    case seconds10 = 10
    case seconds20 = 20
    case seconds60 = 60
    case minutes5 = 300

    var stringValue: String {
            switch self {
            case .seconds2: return "2s"
            case .seconds10: return "10s"
            case .seconds20: return "20s"
            case .seconds60: return "60s"
            case .minutes5: return "5min"
            }
    }
}

class RefreshTimerService: ObservableObject {
    @Published var isActive = false
    private var selectedUpdateInterval: RefreshIntervalOptions?
    private var timer: Timer?
    private var fireFunction: (() async -> Void)?

    init() {
//        getSelectedUpdateInterval()
//        let rawValue = UserDefaults.standard.integer(forKey: "selectedRefreshInterval")
//        selectedUpdateInterval = RefreshIntervalOptions(rawValue: rawValue)
    }

    private func getSelectedUpdateInterval() {
        let rawValue = UserDefaults.standard.integer(forKey: "selectedRefreshInterval")
        selectedUpdateInterval = RefreshIntervalOptions(rawValue: rawValue)
    }

    private func getRefreshIsActivated() -> Bool {
        return UserDefaults.standard.bool(forKey: "refreshRegularly")

    }

    func startRefreshTimerIfActivatedInSettings() {
        guard
            getRefreshIsActivated() == true
        else { return }

        getSelectedUpdateInterval()

        guard
            let duration = selectedUpdateInterval
        else { return }

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration.rawValue),
                                     repeats: true) { _ in
            NotificationCenter.default.post(name: NSNotification.Name("TimerFired"), object: nil)
        }
        isActive = true
        print("Timer activated: \(selectedUpdateInterval?.rawValue)")
    }

    func stopRefreshTimer() {
        timer?.invalidate()
        timer = nil
        isActive = false
        print("Timer is deactivated")
    }

    func resetTimer() {
        stopRefreshTimer()
        if !isActive {
            startRefreshTimerIfActivatedInSettings()
        }
    }
}
