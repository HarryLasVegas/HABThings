//
//  ViewModifiers.swift
//  HABThings
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
            .cornerRadius(7)
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

// Bottom buttons
struct BottomButtonsStyle: ButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color
    var pressedColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
          .padding([.top, .bottom], 5)
          .padding([.leading, .trailing])
          .foregroundColor(foregroundColor)
          .background(configuration.isPressed ? pressedColor : backgroundColor)
          .cornerRadius(5)
    }
}

extension View {
    func bottomButtonStyle(
        foregroundColor: Color = .secondary,
        backgroundColor: Color = Color.theme.systemGroupedBackground.opacity(0.5),
        pressedColor: Color = .gray.opacity(0.5)
      ) -> some View {
        self.buttonStyle(
            BottomButtonsStyle(
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            pressedColor: pressedColor
          )
        )
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

// Onboarding Button
struct IOSButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 200)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
