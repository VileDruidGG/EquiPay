//
//  MainTabItem.swift
//  MainTab
//
//  Created by Christofher Ontiveros Espino on 27/10/25.
//
import Foundation
import SwiftUI

public enum MainTabItem: Hashable {
    case home
    case expenses
    case add
    case history
    case profile

    var title: String {
        switch self {
        case .home:     return "Inicio"
        case .expenses: return "Grupos"
        case .add:      return "Crear"
        case .history:  return "Actividad"
        case .profile:  return "Perfil"
        }
    }

    var systemImageName: String {
        switch self {
        case .home:     return "house"
        case .expenses: return "person.2"
        case .add:      return "plus"
        case .history:  return "bell"
        case .profile:  return "person"
        }
    }

    @ViewBuilder
    var icon: some View {
        Image(systemName: systemImageName)
    }
}
