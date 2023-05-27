//
//  ItemsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import SwiftUI

struct ItemsView: View {
    @StateObject var viewModel = ItemsViewModel()

    var body: some View {
        List(viewModel.items) { item in
            HStack {
                Text(item.name)
                Spacer()
                Text(item.state ?? "")
            }
            .font(.subheadline)
        }
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
