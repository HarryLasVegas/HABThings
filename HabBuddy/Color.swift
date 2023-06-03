//
//  Color.swift
//  HabBuddy
//
//  Created by Stephan Weber on 03.06.23.
//

import Foundation
import SwiftUI

extension Color {
    let theme = ColorTheme()
}

struct ColorTheme {
    let online = Color.green
    let offline = Color.red
    let initializing = Color.orange
    let removing = Color.orange
    let uninitialized = Color.gray
    let unknown = Color.gray
    let removed = Color.gray
}
