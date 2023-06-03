//
//  ThingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import SwiftUI

struct ThingsListView: View {
    @StateObject var vm = ThingsListViewModel()
    @State private var refreshButtonAnimation = false
    @State private var refreshButtonRotationAngle: Double = 0

    var body: some View {
        VStack {
            HStack {
                Spacer()
                refreshButton
            }

            List {
                ForEach(Status.allCases, id: \.rawValue) { status in
                    Section(status.rawValue.uppercased()) {
                        if vm.thingsWithStatusPresent(for: status.rawValue) {
                            ForEach(vm.things) { thing in
                                if thing.viewStatus.lowercased() == status.rawValue.lowercased() {
                                    HStack {
                                        Text(thing.viewLabel)
                                        Spacer()
                                        Text(thing.viewStatus)
                                            .padding(2)
                                            .padding([.leading, .trailing], 5)
                                            .foregroundColor(Color.theme.statusForeground)
                                            .background(thing.viewStatusColor)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                        } else {
                            Text("-")
                        }
                    }
                }
            }
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
                await vm.fetchThings()
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
        .padding([.trailing, .top], 10)
    }
}

//extension ThingsListView {
//    private var offlineList: some View {
//        Section("OFFLINE") {
//            ForEach(vm.offlineThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var onlineList: some View {
//        Section("ONLINE") {
//            ForEach(vm.onlineThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var removingList: some View {
//        Section("REMOVING") {
//            ForEach(vm.removingThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var uninitializedList: some View {
//        Section("UNINITIALIZED") {
//            ForEach(vm.uninitializedThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var removedList: some View {
//        Section("REMOVED") {
//            ForEach(vm.removedThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var unknownList: some View {
//        Section("UNKOWN") {
//            ForEach(vm.unknownThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//
//    private var initializingList: some View {
//        Section("INITIALIZING") {
//            ForEach(vm.initializingThings) { thing in
//                HStack {
//                    Text(thing.viewLabel )
//                    Spacer()
//                    Text(thing.viewStatus)
//                }
//            }
//        }
//    }
//}
