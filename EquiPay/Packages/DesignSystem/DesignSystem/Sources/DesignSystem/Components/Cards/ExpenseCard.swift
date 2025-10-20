//
//  ExpenseCard.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 20/10/25.
//
import SwiftUI

public enum ExpenseStatus: String {
    case pending
    case paid
    case overpaid
    case canceled
    case unpaid
    case completed
}
public struct ExpenseCard: View {
    private let icon: String
    private let title: String
    private let participantsAmount: Int
    private let amount: String
    private let status: ExpenseStatus
    
 public init(icon: String, title: String, participantsAmount: Int, amount: String, status: ExpenseStatus) {
        self.icon = icon
        self.title = title
        self.participantsAmount = participantsAmount
        self.amount = amount
        self.status = status
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .font(.caption)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text("\(participantsAmount) Participant\(participantsAmount == 1 ? "" : "s")")
            }
            VStack{
                Text(amount)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(status.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
