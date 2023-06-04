//
//  Things.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation
import SwiftUI

// Source: http://192.168.178.45:8080/rest/things
// apiToken: oh.habBuddyToken.LlvKRbWd6AgGjdxH2mbU1VyMFpksF7Wwlin8qjDpCCa9Vuoi2AQKyz9VLyw6XcheKZOLUQvnO3U2zvqmw

struct Thing: Codable, Identifiable {
    let statusInfo: StatusInfo?
    let label: String?
    let uid: String?
    let location: String?

    var id = UUID()

    var viewLabel: String { label ?? "No name"}
    var viewStatus: String {
        if let statusString = statusInfo?.status?.rawValue {
            return statusString
        } else {
            return "unknown"
        }
    }
    var viewStatusColor: Color {
        if let color = statusInfo?.status?.color {
            return color
        } else {
            return Color.theme.unknown
        }
    }

    private enum CodingKeys: String, CodingKey { case statusInfo, label, uid, location }
}

struct StatusInfo: Codable {
    let status: Status?
    let description: String?
}

enum Status: String, Codable, CaseIterable {
    case offline = "OFFLINE"
    case online = "ONLINE"
    case initializing = "INITIALIZING"
    case uninitialized = "UNINITIALIZED"
    case removing = "REMOVING"
    case removed = "REMOVED"
    case unknown = "UNKNOWN"

    var color: Color {
        switch self {
        case .offline:
            return Color.theme.offline
        case .online:
            return Color.theme.online
        case.initializing:
            return Color.theme.initializing
        case .uninitialized:
            return Color.theme.uninitialized
        case .removing:
            return Color.theme.removing
        case .removed:
            return Color.theme.removed
        case .unknown:
            return Color.theme.unknown
        }
    }
}
