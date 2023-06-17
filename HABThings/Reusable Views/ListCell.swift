//
//  ListCell.swift
//  HABThings
//
//  Created by Stephan Weber on 09.06.23.
//

import SwiftUI

struct ListCell: View {
    var leading: String
    var trailing: String

    var body: some View {
        HStack {
            Text(leading)
            Spacer()
            Text(trailing)
                .foregroundColor(.secondary)
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListCell(leading: "Hallo", trailing: "Test")
    }
}
