//
//  View.swift
//  HabBuddy
//
//  Created by Stephan Weber on 07.06.23.
//

import SwiftUI

extension View {
    func insetGroupedStyle(header: String) -> some View {
        return GroupBox(label: Text(header.uppercased())
            .font(.headline)
            .padding(.top)
            .padding(.bottom, 0)) {
                    VStack {
                        self.padding(.vertical, 1)
                    }.padding(.horizontal).padding(.vertical, 5)
                }
    }
}

// Usage Example
//    Section {
//        ListCell(leading: "String", trailing: "String")
//    }
//    .insetGroupedStyle(header: "String")
