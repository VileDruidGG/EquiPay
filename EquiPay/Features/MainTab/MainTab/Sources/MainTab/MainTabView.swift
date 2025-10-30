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

            coordinator.makeProfile()
                .tabItem {
                    MainTabItem.expenses.icon
                    Text(MainTabItem.expenses.title)
                }
                .tag(MainTabItem.expenses)
            
            coordinator.makeProfile()
                .tabItem {
                    MainTabItem.add.icon
                    Text(MainTabItem.add.title)
                }
                .tag(MainTabItem.add)
            
            coordinator.makeProfile()
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
    }
}

#Preview {
    MainTabView()
}


