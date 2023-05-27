//
//  Item.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import Foundation

// MARK: - Item
struct Item: Codable, Identifiable {
    let type, name: String
    let label, category: String?
    let tags, groupNames: [String]
    let link, state, transformedState: String?
    let stateDescription: StateDescription?
    let commandDescription: CommandDescription?
    let metadata: Metadata?
    let editable: Bool

    var id: String { name }
}

// MARK: - CommandDescription
struct CommandDescription: Codable {
    let commandOptions: [CommandOption]
}

// MARK: - CommandOption
struct CommandOption: Codable {
    let command, label: String
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - StateDescription
struct StateDescription: Codable {
    let minimum, maximum, step: Int?
    let pattern: String?
    let readOnly: Bool
    let options: [Option]
}

// MARK: - Option
struct Option: Codable {
    let value, label: String
}

typealias Request = [Item]
