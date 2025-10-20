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
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(Color.green)
                .font(.subheadline)
                .frame(width: 36, height: 36)
                .background(RoundedRectangle(cornerRadius: 50)
                    .fill(Color.mint.opacity(0.1)))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text("\(participantsAmount) participant\(participantsAmount == 1 ? "" : "s")")
            }
            Spacer()
            VStack{
                Text(amount)
                    .font(.headline)
                    .foregroundColor(.green)
                Text(status.rawValue)
                    .font(.footnote)
                    .foregroundColor(.green)
                    .padding(10)
                    .frame(width: .infinity, height: 20)
                    .background(RoundedRectangle(cornerRadius: 50)
                        .fill(Color.mint.opacity(0.1)))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.8), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                )
            )
    }
}
