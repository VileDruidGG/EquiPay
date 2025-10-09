//
//  EquiPayApp.swift
//  EquiPay
//
//  Created by Christofher Ontiveros Espino on 01/10/25.
//

import SwiftUI
import Onboarding
import Auth

enum SheetRoute: Identifiable {
    case auth(AuthRoute)
    var id: String {
        switch self {
        case .auth(let r): return "auth-\(r)"
        }
    }
}

@main
struct EquiPayApp: App {
    
    @State private var sheetRoute: SheetRoute? = nil
    
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(
                vm: OnboardingViewModel(
                    onLogin: {sheetRoute = .auth(.login)},
                    onSignup: {sheetRoute = .auth(.signup)}
                )
            )
            .fullScreenCover(item: $sheetRoute) { route in
                            switch route {
                            case .auth(let initial):
                                AuthContainer.makeAuthRoot(initial) {
                                    // Se cerró Auth (login o signup terminado)
                                    sheetRoute = nil
                                    // Aquí navegas a tu “Home/Main” si quieres.
                                }
                            }
                        }
        }
    }
}




