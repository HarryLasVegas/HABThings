//
//  Things.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import Foundation

// Source: http://192.168.178.45:8080/rest/things

struct Thing: Codable, Identifiable {
    let statusInfo: StatusInfo?
    let label: String?
    let uid: String?
    let location: String?

    var id = UUID()

    var viewLabel: String { label ?? "No name"}
    var viewStatus: String {
        if let statusInfoString = statusInfo?.status?.rawValue {
            return statusInfoString
        } else {
            return "unknown"
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
}
