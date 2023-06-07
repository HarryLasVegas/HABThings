//
//  ThingsView.swift
//  HabBuddy
//
//  Created by Stephan Weber on 02.06.23.
//

import SwiftUI

struct ThingsListView: View {
    @StateObject var vm: ThingsListViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var refreshTimerService: RefreshTimerService

    @State private var refreshButtonAnimation = false
    @State private var refreshButtonRotationAngle: Double = 0
    @State private var searchBarIsShown = false

    @FocusState private var focusField: FocusField?

//    let refreshTimer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            headerView

            if searchBarIsShown {
                searchTextField
            }

            listView
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
                await vm.fetchThings()
                refreshTimerService.startRefreshTimerIfActivatedInSettings()
            }
            .onChange(of: settingsManager.settingsChanged) { _ in
                Task {
                    settingsManager.settingsChanged = false
                    await vm.fetchThings()
                }
            }
        }
//        .onReceive(refreshTimer, perform: { _ in
//            print("updating")
//            Task {
//                await vm.fetchThings()
//            }
//        })
    }

    // Initializer is needed for passing the EO settingsManager to the ViewModel
    init(settingsManager: SettingsManager,
         refreshTimerService: RefreshTimerService) {
        let vm = ThingsListViewModel(settingsManager: settingsManager,
                                     refreshTimerService: refreshTimerService)
        _vm = StateObject(wrappedValue: vm)
    }

}

struct ThingsListView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsManager = SettingsManager()
        let refreshTimerService = RefreshTimerService()
        ThingsListView(settingsManager: settingsManager,
                       refreshTimerService: refreshTimerService)
        .environmentObject(settingsManager)
    }
}

extension ThingsListView {
    private var headerView: some View {
        HStack {
            Text("\(vm.amountOfThings) Things")
                .font(.headline)
                .foregroundColor(.secondary)

            Spacer()

            if vm.lastFetchFailed ?? false {
                errorIcon
            }

            searchButton

            refreshButton
        }
        .padding(10)
        .background(.ultraThickMaterial)
    }

    private var listView: some View {
        List {
            ForEach(Status.allCases, id: \.rawValue) { status in
                Section(status.rawValue.uppercased()) {
                    if vm.thingsWithStatusPresent(for: status.rawValue) {
                        ForEach(vm.filteredThings) { thing in
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
    }

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
        .iconButtonStyle()
        .help("Refresh")
    }

    private var searchButton: some View {
        Button {
            withAnimation {
                searchBarIsShown.toggle()
                focusField = .searchField
            }
        } label: {
            Image(systemName: "magnifyingglass")
        }
        .iconButtonStyle()
        .help("Search")

    }

    private var errorIcon: some View {
        Label("Error", systemImage: "exclamationmark.triangle.fill")
            .labelStyle(.iconOnly)
            .foregroundColor(.yellow)
            .help("No connection to openHAB server!")
    }

    private var searchTextField: some View {
        HStack {
            TextField("Search", text: $vm.searchText, prompt: Text("Search ...."))
                .focused($focusField, equals: .searchField)
                .textFieldStyle(.roundedBorder)

            Spacer()

            Button {
                vm.searchText = ""
                withAnimation {
                    searchBarIsShown.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle")
            }
            .buttonStyle(.borderless)
            .focusable(false)
            .controlSize(.large)
        }
        .padding(10)
    }

    enum FocusField: Hashable {
        case searchField
      }
}
