//
//  LoginViewModel.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import Foundation

@MainActor
public final class LoginViewModel: ObservableObject {

    // MARK: - Input (estado editable)
    @Published public var email: String = ""
    @Published public var password: String = ""

    // MARK: - Callbacks hacia el coordinator
    private let onSignUpTap: () -> Void
    private let onSuccess: () -> Void
    private let onCancel: () -> Void

    // MARK: - Init
    public init(
        onSignUpTap: @escaping () -> Void,
        onSuccess: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.onSignUpTap = onSignUpTap
        self.onSuccess = onSuccess
        self.onCancel = onCancel
    }

    // MARK: - Actions
    public func login() {
        // TODO lógica real de autenticación (validación, servicio, etc.)
        guard !email.isEmpty, !password.isEmpty else {
            print("Campos vacíos")
            return
        }

        // Simulación de login correcto
        print("Login con \(email)")
        onSuccess()
    }

    public func goToSignUp() {
        onSignUpTap()
    }

    public func cancel() {
        onCancel()
    }
}
