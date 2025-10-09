//
//  AuthContainer.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI

public struct AuthContainer {
    ///Devuelve la  vista root según la ruta inicial
    /// 'onFinished' se llamará cuando el fluejo termine
    ///
    @MainActor
    public static func makeAuthRoot(_ route: AuthRoute,
                                    onFinished: @escaping () -> Void) -> some View {
        AuthRootView(route: route, onFinished: onFinished)
    }
}

// MARK: - Raíz interna
@MainActor
private struct AuthRootView: View {
    @StateObject private var coordinator: AuthCoordinator
    
    init(route: AuthRoute,
         onFinished: @escaping () -> Void) {
        _coordinator = StateObject(
            wrappedValue: AuthCoordinator(route: route, onFinished: onFinished)
        )
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(title(for: coordinator.route))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Finish") {coordinator.finish()}
                    }
                }
            
        }
    }
    
    
    @ViewBuilder
    private var content: some View {
        switch coordinator.route {
        case .login:
            LoginPlaceholderView(
                onSignUpTap: {coordinator.goToSignUp()}, onSuccess: {coordinator.finish()}
            )
        case .signup:
            SignUpPlaceholderView(
                onHaveAccountTap: {coordinator.goToLogin()}, onSuccess: {coordinator.finish()}
            )
        }
    }
    
    private func title(for route: AuthRoute) -> String {
        switch route {
        case .login:
            return "Login"
        case .signup:
            return "Sign Up"
        }
    }
}

// MARK: - Placeholders temporales
private struct LoginPlaceholderView: View {
    let onSignUpTap: () -> Void
    let onSuccess:   () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Login (placeholder)")
            Button("Go to Sign Up", action: onSignUpTap)
            Button("Finish", action: onSuccess)
        }
        .padding()
    }
}

private struct SignUpPlaceholderView: View {
    let onHaveAccountTap: () -> Void
    let onSuccess:        () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Sign Up (placeholder)")
            Button("I already have an account", action: onHaveAccountTap)
            Button("Finish", action: onSuccess)
        }
        .padding()
    }
}
