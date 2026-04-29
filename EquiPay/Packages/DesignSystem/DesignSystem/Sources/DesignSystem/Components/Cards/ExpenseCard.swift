//
//  ExpenseCard.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 20/10/25.
//
import SwiftUI

/// Estado del grupo/gasto.
/// - pending:   hay montos sin liquidar
/// - settled:   el usuario ya hizo su pago (auto-reportado)
/// - completed: el dueño del grupo confirmó que el pago se reflejó
/// - canceled:  el gasto fue cancelado
///
/// Android equivalent: enum class ExpenseStatus
public enum ExpenseStatus {
    case pending
    case settled
    case completed
    case canceled

    /// Etiqueta visible en la UI (español)
    public var label: String {
        switch self {
        case .pending:   return "Pendiente"
        case .settled:   return "Saldado"
        case .completed: return "Completado"
        case .canceled:  return "Cancelado"
        }
    }

    /// Color del badge de estado
    public var badgeColor: Color {
        switch self {
        case .pending:   return Color.orange.opacity(0.15)
        case .settled:   return Color.gray.opacity(0.15)
        case .completed: return Color.green.opacity(0.15)
        case .canceled:  return Color.red.opacity(0.15)
        }
    }

    /// Color del texto del badge
    public var badgeTextColor: Color {
        switch self {
        case .pending:   return Color.orange
        case .settled:   return Color.gray
        case .completed: return Color.green
        case .canceled:  return Color.red
        }
    }
}

/// Dirección del balance desde el punto de vista del usuario actual.
/// - positive: te deben (verde)
/// - negative: tú debes (rojo)
/// - neutral:  sin balance pendiente
///
/// Android equivalent: enum class BalanceDirection
public enum BalanceDirection {
    case positive
    case negative
    case neutral

    public var color: Color {
        switch self {
        case .positive: return Color.green
        case .negative: return Color.red
        case .neutral:  return Color.gray
        }
    }

    public var prefix: String {
        switch self {
        case .positive: return "+"
        case .negative: return ""
        case .neutral:  return ""
        }
    }
}

public struct ExpenseCard: View {
    private let icon: String
    private let iconBackground: Color
    private let title: String
    private let participantsAmount: Int
    private let amount: String
    private let status: ExpenseStatus
    private let balanceDirection: BalanceDirection

    public init(
        icon: String,
        iconBackground: Color = Color.mint.opacity(0.15),
        title: String,
        participantsAmount: Int,
        amount: String,
        status: ExpenseStatus,
        balanceDirection: BalanceDirection = .neutral
    ) {
        self.icon = icon
        self.iconBackground = iconBackground
        self.title = title
        self.participantsAmount = participantsAmount
        self.amount = amount
        self.status = status
        self.balanceDirection = balanceDirection
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Ícono del grupo
            Image(systemName: icon)
                .foregroundColor(Color.teal)
                .font(.system(size: 18, weight: .medium))
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)
                )

            // Nombre y participantes
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(participantsAmount) participante\(participantsAmount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Monto y badge de estado
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(balanceDirection.prefix)$\(amount)")
                    .font(.headline)
                    .bold()
                    .foregroundColor(balanceDirection.color)

                Text(status.label)
                    .font(.caption)
                    .bold()
                    .foregroundColor(status.badgeTextColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(status.badgeColor)
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}
