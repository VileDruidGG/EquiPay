//
//  EquiPayApp.swift
//  EquiPay
//
//  Created by Christofher Ontiveros Espino on 01/10/25.
//

import SwiftUI
import Onboarding

@main
struct EquiPayApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView(vm: OnboardingViewModel {
                // TODO: navegar a Auth más adelante
            })
        }
    }
}




