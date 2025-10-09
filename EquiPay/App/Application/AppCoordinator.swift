//
//  AppCoordinator.swift
//  EquiPay
//
//  Created by Christofher Ontiveros Espino on 09/10/25.
//

import UIKit
import SwiftUI
import Onboarding
import Auth

@MainActor
final class AppCoordinator {

    // MARK: - Properties
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Entry point
    func start() {
        showOnboarding()
    }

    // MARK: - Onboarding flow
    private func showOnboarding() {
        let vm = OnboardingViewModel(
            onLogin:  { [weak self] in self?.presentAuth(.login) },
            onSignup: { [weak self] in self?.presentAuth(.signup) }
        )

        let onboardingView = OnboardingView(vm: vm)
        let root = UIHostingController(rootView: onboardingView)

        window.rootViewController = root
        window.makeKeyAndVisible()
    }

    // MARK: - Auth flow
    private func presentAuth(_ route: AuthRoute) {
        let authView = AuthContainer.makeAuthRoot(route) { [weak self] in
            // 🔙 Auth terminó (login o signup exitoso)
            self?.window.rootViewController?.dismiss(animated: true) {
                self?.showMainApp()
            }
        }

        let authHost = UIHostingController(rootView: authView)
        authHost.modalPresentationStyle = .fullScreen

        window.rootViewController?.present(authHost, animated: true)
    }

    // MARK: - MainApp (placeholder)
    private func showMainApp() {
        // Aquí en el futuro montarás tu flujo principal (ej. HomeView / TabBar)
        let label = UILabel()
        label.text = "🏠 Main App Placeholder"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)

        let mainVC = UIViewController()
        mainVC.view.backgroundColor = .systemBackground
        mainVC.view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: mainVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: mainVC.view.centerYAnchor)
        ])

        window.rootViewController = mainVC
    }
}


