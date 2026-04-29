//
//  SummaryCard.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 17/10/25.
//
import SwiftUI

public struct SummaryCard: View {

    private let title: String
    private let amount: String
    private let icon: String

    public init(title: String, amount: String, icon: String) {
        self.title = title
        self.amount = amount
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            Text(title)
                .font(.caption)
                .foregroundColor(Color.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)

            Text(amount)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.35), lineWidth: 1)
                )
        )
    }
}
