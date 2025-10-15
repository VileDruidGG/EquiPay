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
    
    // Fábricas inmutables (no se recrean en body)
    private let loginVMFactory: () -> LoginViewModel
    private let signUpVMFactory: () -> SignUpViewModel

    
    init(route: AuthRoute, onFinished: @escaping () -> Void) {
        let coord = AuthCoordinator(route: route, onFinished: onFinished)
        _coordinator = StateObject(wrappedValue: coord)

        self.loginVMFactory = { [weak coord] in
            LoginViewModel(
                onSignUpTap: { coord?.goToSignUp() },
                onSuccess:   { coord?.finish() }
            )
        }
        
        self.signUpVMFactory = { [weak coord] in
            SignUpViewModel(
                onLoginTap: { coord?.goToLogin() },
                onSuccess: { coord?.finish() }
            )
        }
         
    }
    
    var body: some View {
        NavigationStack {
            content
        }
    }
    
    
    @ViewBuilder
    private var content: some View {
        switch coordinator.route {
        case .login:
            LoginView(vm: loginVMFactory())
        case .signup:
            SignUpView(vm:  signUpVMFactory())
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
