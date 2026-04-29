//
//  QuickActionCard.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 24/10/25.
//
import SwiftUI

public struct QuickActionCard: View {
    private let title: String
    private let icon: String
    private let isPrincipal: Bool

    public init(title: String, icon: String, isPrincipal: Bool) {
        self.title = title
        self.icon = icon
        self.isPrincipal = isPrincipal
    }

    public var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(isPrincipal ? .white : .primary)
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(isPrincipal ? .white : .primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(
            Group {
                if isPrincipal {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [Color.mint, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
            }
        )
    }
}
