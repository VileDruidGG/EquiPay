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
    
    public init() {
        
    }
    
    
}
