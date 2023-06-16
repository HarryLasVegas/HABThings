//
//  BoardingSheet.swift
//  HabBuddy
//
//  Created by Stephan Weber on 16.06.23.
//

import SwiftUI

struct BoardingSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var shouldRefresh: Bool

    @State private var secondPageShown = false

    var body: some View {
        ScrollView {
            if !secondPageShown {
                welcomePart
            } else {
                secondPagePart
            }
        }
        .animation(.easeInOut(duration: 0.5), value: secondPageShown)
        .frame(minWidth: 350, idealWidth: 350, maxWidth: 350,
                       minHeight: 800, idealHeight: 800, maxHeight: 1200,
                       alignment: .topLeading)
    }
}

extension BoardingSheet {
    private var welcomePart: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)

            Text("Welcome to HABbuddy!")
                .font(.title)
            Text("Please enter your access data on the next page. You can always change them at any time.")

            dotsView

            Button("Continue") {
                secondPageShown = true
            }
            .buttonStyle(IOSButtonStyle())
            .focusable(false)
        }
        .padding()
        .padding()
        .padding(.top, 30)
    }

    private var secondPagePart: some View {
        VStack {
            SettingsView(shouldRefresh: $shouldRefresh)

            Spacer()

            dotsView

            Button("Done") {
                dismiss()
            }
            .buttonStyle(IOSButtonStyle())
            .focusable(false)
        }
    }

    private var dotsView: some View {
        HStack {
            Spacer()
            Circle()
                .frame(width: 5)
                .opacity(secondPageShown ? 0.2 : 1)
            Circle()
                .frame(width: 5)
                .opacity(secondPageShown ? 1 : 0.2)
            Spacer()
        }
        .foregroundColor(.primary)
        .padding()
    }
}

struct BoardingSheet_Previews: PreviewProvider {
    static var previews: some View {
        BoardingSheet(shouldRefresh: .constant(true))
    }
}
