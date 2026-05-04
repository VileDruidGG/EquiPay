//
//  MainTabCoordinator.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import SwiftUI
import Home
import Groups

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
        Text("Crear")
    }

    @ViewBuilder
    public func makeActivity() -> some View {
        Text("Actividad")
    }

    @ViewBuilder
    public func makeProfile() -> some View {
        Text("Perfil")
    }
}
