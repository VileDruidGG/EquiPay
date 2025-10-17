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
    private let color: Color
    
   public init(title: String, amount: String, icon: String, color: Color) {
        self.title = title
        self.amount = amount
        self.icon = icon
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon).foregroundColor(color)
            GeometryReader { geometry in
                Text(title)
                    .lineLimit(nil)
                    .frame(width: geometry.size.width, alignment: .leading)
            }
            .frame(height: 50)
            Text(amount)
                .font(.title).bold()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 140, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.2))
                )
        )
        
    }
}
