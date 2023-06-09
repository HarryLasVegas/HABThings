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

// MARK: Settings Boxes
struct SettingsBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.thinMaterial)
            .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(.gray, lineWidth: 0.5)
            )
    }
}

extension View {
    func settingsBoxStyle() -> some View {
        modifier(SettingsBoxModifier())
    }
}

// Borderless buttons, non focusable
struct IconButtonsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderless)
            .focusable(false)
            .controlSize(.large)
    }
}

extension View {
    func iconButtonStyle() -> some View {
        modifier(IconButtonsModifier())
    }
}

// MARK: Labels with tinted labels
struct ColorfulIconLabelStyle: LabelStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
                .offset(x: 7)
        } icon: {
            configuration.icon
                .font(.system(size: 13))
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 7).frame(width: 24, height: 24).foregroundColor(color))
        }
    }
}
