//
//  MainTabView.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import SwiftUI
import DesignSystem

@MainActor
public struct MainTabView: View {
    @StateObject private var viewModel: MainTabViewModel
    private let coordinator: MainTabCoordinator

    public init(
        viewModel: MainTabViewModel = MainTabViewModel(),
        coordinator: MainTabCoordinator = MainTabCoordinator()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    public var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            coordinator.makeHome()
                .tabItem {
                    MainTabItem.home.icon
                    Text(MainTabItem.home.title)
                }
                .tag(MainTabItem.home)

            coordinator.makeGroups(selectedTab: Binding(
                get: { viewModel.selectedTabIndex },
                set: { viewModel.selectedTabIndex = $0 }
            ))
                .tabItem {
                    MainTabItem.expenses.icon
                    Text(MainTabItem.expenses.title)
                }
                .tag(MainTabItem.expenses)

            coordinator.makeAdd()
                .tabItem {
                    MainTabItem.add.icon
                    Text(MainTabItem.add.title)
                }
                .tag(MainTabItem.add)

            coordinator.makeActivity()
                .tabItem {
                    MainTabItem.history.icon
                    Text(MainTabItem.history.title)
                }
                .tag(MainTabItem.history)

            coordinator.makeProfile()
                .tabItem {
                    MainTabItem.profile.icon
                    Text(MainTabItem.profile.title)
                }
                .tag(MainTabItem.profile)
        }
        .tint(Color(red: 0.24, green: 0.78, blue: 0.75))
    }
}

#Preview {
    MainTabView()
}
