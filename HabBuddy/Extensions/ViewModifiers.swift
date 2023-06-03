//
//  ViewModifiers.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import SwiftUI

// Statusbeans
struct StatusBeanModifier: ViewModifier {
    let bgColor: Color

    func body(content: Content) -> some View {
        content
            .padding(2)
            .padding([.leading, .trailing], 2)
            .foregroundColor(Color.theme.statusForeground)
            .background(bgColor)
            .cornerRadius(5)
            .font(.subheadline)
    }
}

extension Text {
    func statusBeanStyle(bgColor: Color) -> some View {
        modifier(StatusBeanModifier(bgColor: bgColor))
    }
}
