//
//  Color.swift
//  HABThings
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let online = Color("flatGreen")
    let offline = Color.red
    let initializing = Color("flatYellow")
    let removing = Color("flatYellow")
    let uninitialized = Color.gray
    let unknown = Color.gray
    let removed = Color.gray

    let statusForeground = Color.white
}
