//
//  OnboardingViewModel.swift
//  Onboarding
//
//  Created by Christofher Ontiveros Espino on 02/10/25.
//
import Foundation

public final class OnboardingViewModel: ObservableObject {
    private let onLoginAction:  () -> Void
    private let onSignupAction: () -> Void

    public init(onLogin: @escaping () -> Void,
                onSignup: @escaping () -> Void) {
        self.onLoginAction = onLogin
        self.onSignupAction = onSignup
    }

    public func login()  { onLoginAction() }
    public func signup() { onSignupAction() }
}
