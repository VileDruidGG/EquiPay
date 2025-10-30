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
        case .home: return "Home"
        case .expenses: return "Expenses"
        case .add: return "Add"
        case .history: return "History"
        case .profile: return "Profile"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .home: return "house"
        case .expenses: return "cart.fill"
        case .add: return "plus"
        case .history: return "clock"
        case .profile: return "person"
        }
    }
    
    @ViewBuilder
    var icon: some View {
        Image(systemName: systemImageName)
    }
}
