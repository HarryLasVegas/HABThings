//
//  ThingDetailView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 08.06.23.
//

import SwiftUI

struct ThingDetailView: View {
    var thing: Thing

    var body: some View {
        Text(thing.viewLabel)
            .navigationTitle(thing.viewLabel)
    }
}

struct ThingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThingDetailView(thing: Thing.mockThing)
    }
}
