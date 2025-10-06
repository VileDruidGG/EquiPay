//
//  SecondaryButton.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 06/10/25.
//
import SwiftUI

public struct SecondaryButton: View {
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
            .overlay(Capsule().stroke(lineWidth: 1))
            .hoverEffect(.lift)
            .foregroundColor(.black)
            .clipShape(Capsule())
    }
}
