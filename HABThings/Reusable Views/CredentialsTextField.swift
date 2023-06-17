//
//  CredentialsTextField.swift
//  HABThings
//
//  Created by Stephan Weber on 14.06.23.
//

import SwiftUI

struct CredentialsTextField: View {
    let label: String
    let placeholder: String
    @Binding var fieldValue: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .offset(x: 3)
            TextField(placeholder, text: $fieldValue)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom, 5)
        }
    }
}

struct CredentialsTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CredentialsTextField(label: "Label", placeholder: "Placeholder", fieldValue: .constant("Hallo"))
            CredentialsTextField(label: "Label", placeholder: "Placeholder", fieldValue: .constant("Hallo"))
            CredentialsTextField(label: "Label", placeholder: "Placeholder", fieldValue: .constant("Hallo"))
            CredentialsTextField(label: "Label", placeholder: "Placeholder", fieldValue: .constant("Hallo"))
        }
    }
}
