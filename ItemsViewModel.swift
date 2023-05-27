//
//  ItemsViewModel.swift
//  HabBuddy
//
//  Created by Stephan Weber on 25.05.23.
//

import Foundation

@MainActor class ItemsViewModel: ObservableObject {
    @Published var items: [Item]
//    let urlString = "http://192.168.178.45:8080/rest/items?recursive=false"
    let urlString = "http://194.28.183.134:8080/rest/items?recursive=false"

    init() {
        self.items = []
    }

    private func getItems() async -> [Item] {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return []
        }

        do {
            let decodedResponse = try await URLSession.shared.decode([Item].self, from: url)
            items = decodedResponse

        } catch let jsonError as NSError {
            print("Decoding failed: \(jsonError.localizedDescription)")
            print("Decoding failed: \(jsonError.userInfo)")
            print("ERROR: \(jsonError)")
        }

        return items.sorted(by: { $0.name < $1.name })
    }

    func refresh() async {
        items = await getItems()
    }

}
