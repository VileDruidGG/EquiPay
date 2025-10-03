//
//  OnboardingViewModel.swift
//  Onboarding
//
//  Created by Christofher Ontiveros Espino on 02/10/25.
//
import Foundation

public final class OnboardingViewModel: ObservableObject {
    public let startAuth: () -> Void
    public init(startAuth: @escaping () -> Void) { self.startAuth = startAuth }
}

