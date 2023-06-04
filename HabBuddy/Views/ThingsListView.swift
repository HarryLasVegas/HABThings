//
//  ThingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import SwiftUI

struct ThingsListView: View {
    @StateObject var vm = ThingsListViewModel()
//    private var keyChainManager = KeychainManager()

//    @State private var urlString: String = ""
//    @State private var apiToken: String = ""

    @State private var shouldRefresh = false

    @State private var refreshButtonAnimation = false
    @State private var refreshButtonRotationAngle: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("URL: \(vm.urlString)")
                Text("Token: \(vm.apiToken)")
            }
            HStack {
                Text("\(vm.amountOfThings) Things registered")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                refreshButton
            }
//            .padding([.leading, .trailing, .top], 10)
            .padding(10)
            .background(.ultraThickMaterial)

            List {
                ForEach(Status.allCases, id: \.rawValue) { status in
                    Section(status.rawValue.uppercased()) {
                        if vm.thingsWithStatusPresent(for: status.rawValue) {
                            ForEach(vm.things) { thing in
                                if thing.viewStatus.lowercased() == status.rawValue.lowercased() {
                                    HStack {
                                        Text(thing.viewLabel)
                                            .help(thing.viewLabel)
                                        Spacer()
                                        Text(thing.viewStatus)
                                            .statusBeanStyle(bgColor: thing.viewStatusColor)
                                    }
                                }
                            }
                        } else {
                            Text("-")
                        }
                    }
                }
            }
            .padding(.top, 0)
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .listStyle(.sidebar)
            .task {
                vm.fetchCredentials()
                await vm.fetchThings()

                print("TASK")
            }
            .onAppear {
                print("ONAPPEAR")
            }
            .onDisappear {
                print("ONDISAPPEAR")
            }
        }
    }
}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        ThingsListView()
    }
}

extension ThingsListView {

    private var refreshButton: some View {
        Button {
            Task {
                vm.fetchCredentials()
                await vm.fetchThings()
            }
            refreshButtonAnimation.toggle()
            withAnimation(.easeOut(duration: 0.2)) {
                            refreshButtonRotationAngle += 180
            }
            refreshButtonRotationAngle = refreshButtonAnimation ? 180 : 0
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .rotationEffect(.degrees(refreshButtonRotationAngle))
        }
        .buttonStyle(.borderless)
        .focusable(false)
        .controlSize(.large)
//        .padding([.trailing, .top], 10)
    }
}
