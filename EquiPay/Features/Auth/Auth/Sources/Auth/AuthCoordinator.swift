//
//  AuthCoordinator.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import Foundation

@MainActor
final class AuthCoordinator: ObservableObject {
    @Published var route: AuthRoute
    private let onFinished: () -> Void
    
    init(route: AuthRoute, onFinished: @escaping () -> Void) {
        self.route = route
        self.onFinished = onFinished
    }
    
    func goToLogin(){route = .login}
    func goToSignUp(){route = .signup}
    func finish() {onFinished()}
}
