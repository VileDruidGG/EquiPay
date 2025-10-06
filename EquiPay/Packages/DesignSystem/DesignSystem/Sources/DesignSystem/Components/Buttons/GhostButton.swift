//
//  GhostButton.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 06/10/25.
//
import SwiftUI

public struct GhostButton: View {
    private let title: String
    private let action: () -> Void

    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(title, action: action)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .overlay(Capsule().stroke(LinearGradient(gradient: Gradient(colors: [.mint, .purple]), startPoint: .leading, endPoint: .trailing), lineWidth: 3))
            .foregroundColor(.black)
    }
}


