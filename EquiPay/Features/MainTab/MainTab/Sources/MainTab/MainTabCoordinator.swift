//
//  MainTabCoordinator.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import SwiftUI
import Home
import Groups
import CreateGroup
import Activity
import Profile

@MainActor
public struct MainTabCoordinator {

    public init() {}

    @ViewBuilder
    public func makeHome() -> some View {
        HomeView()
    }

    @ViewBuilder
    public func makeGroups(selectedTab: Binding<Int>) -> some View {
        GroupsView(selectedTab: selectedTab)
    }

    @ViewBuilder
    public func makeAdd() -> some View {
        CreateGroupView()
    }

    @ViewBuilder
    public func makeActivity() -> some View {
        ActivityView()
    }

    @ViewBuilder
    public func makeProfile() -> some View {
        ProfileView()
    }
}
