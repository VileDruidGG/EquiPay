//
//  SignUpViewModel.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import Foundation

@MainActor
public final class SignUpViewModel: ObservableObject {
    
    // Input
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""
    @Published public var fullName: String = ""
    
    //Callbacks hacia el coordinator
    private let onLoginTap: () -> Void
    private let onSuccess: () -> Void
    private let onCancel: () -> Void
    
    //Init
    public init(
        onLoginTap: @escaping () -> Void,
        onSuccess: @escaping () -> Void,
        onCancel: @escaping () -> Void = {}
    ) {
        self.onLoginTap = onLoginTap
        self.onSuccess = onSuccess
        self.onCancel = onCancel
    }
    
    //Actions
    public func cancel() {
        onCancel()
    }
    
    public func signup() {
        //TODO logica real de auth
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty, !confirmPassword.isEmpty else {
            print("campos vacios")
            return
        }
        print("Usuario \(fullName) creado con éxito")
        onSuccess()
    }
    
    public func goToLogin() {
        onLoginTap()
    }
}
