//
//  MainTabCoordinator.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import SwiftUI
import Home


@MainActor
public struct MainTabCoordinator {
    
    public init() {}
    
    @ViewBuilder
    public func makeHome() -> some View {
        HomeView()
    }
    
    @ViewBuilder
    public func makeExpenses() -> some View {
        Text("Expenses")
    }
    
    @ViewBuilder
    public func makeAdd() -> some View {
        Text("Add")
    }
    
    @ViewBuilder
    public func makeHistory() -> some View {
        Text("Profile")
    }
    
    @ViewBuilder
    public func makeProfile() -> some View {
        Text("Profile")
    }
    
    
}
