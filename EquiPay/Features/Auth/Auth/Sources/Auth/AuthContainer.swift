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
    public static func makeAuthRoot(_ route: AuthRoute,
                                    onFinished: @escaping () -> Void) -> some View {
        AuthRootView(initial: route, onFinished: onFinished)
    }
}

// MARK: - Raíz interna
private struct AuthRootView: View {
    let initial: AuthRoute
    let onFinished: () -> Void
    
    var body: some View {
        
        Group {
            switch initial {
            case .login:
                Text("Login")
                //LoginView()
            case .signup:
                Text("Signup")
                //SignupView()
            }
        }
        .navigationTitle("Auth")
        .toolbar {
            Button("Finish") {
                onFinished
            }
        }
    }
}
