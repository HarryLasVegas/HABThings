//
//  ContentView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ItemsView()

            Divider()

            HStack {
                Button {
                    //
                } label: {
                    Label("1", systemImage: "folder.fill")
                        .labelStyle(.iconOnly)
                }

                Button {
                    //
                } label: {
                    Label("2", systemImage: "folder.fill")
                        .labelStyle(.iconOnly)
                }

                Button {
                    //
                } label: {
                    Label("2", systemImage: "folder.fill")
                        .labelStyle(.iconOnly)
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
