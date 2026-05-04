//
//  MainTabViewModel.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import Foundation
import Combine

@MainActor
public final class MainTabViewModel: ObservableObject {

    @Published public var selectedTab: MainTabItem = .home

    /// Índice entero del tab seleccionado.
    /// GroupsView lo usa como Binding<Int> para saltar al tab Crear
    /// sin importar MainTabItem directamente.
    /// Android equivalent: StateFlow<Int> en MainTabViewModel
    public var selectedTabIndex: Int {
        get {
            switch selectedTab {
            case .home:     return 0
            case .expenses: return 1
            case .add:      return 2
            case .history:  return 3
            case .profile:  return 4
            }
        }
        set {
            switch newValue {
            case 0: selectedTab = .home
            case 1: selectedTab = .expenses
            case 2: selectedTab = .add
            case 3: selectedTab = .history
            case 4: selectedTab = .profile
            default: break
            }
        }
    }

    public init() {}
}
