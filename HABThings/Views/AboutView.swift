//
//  AboutView.swift
//  HABThings
//
//  Created by Stephan Weber on 17.06.23.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)

            Text("HABThings")
                .font(.largeTitle)
            Text("Version: " + (appVersion ?? ""))
            Text("\u{A9} Stephan Weber")
                .font(.caption)
                .padding(.bottom, 5)
            Group {
                Text("""
                    HABThings is a personal project to practice my programming \
                    skills and also have a small app to monitor the things \
                    of my openHAB server.
                    """)
                .padding(.bottom, 5)

                Text("""
                    HABThings is free for personal use. If you encounter any \
                    bugs or have suggestions for future versions, feel free \
                    to write me an email.
                    """)
                Link("info@harrylasvegas.de", destination: URL(string: "mailto:info@harrylasvegas.de")!)
                Text("""
                    But remember: it's a hobby project. So priorities or my skills \
                    may differ from your expectations! 😂
                    """)
            }
//            .fixedSize()
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .navigationTitle("About")
        .padding()
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
