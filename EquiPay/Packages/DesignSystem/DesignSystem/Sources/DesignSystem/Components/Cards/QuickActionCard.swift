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
        VStack{
            Image(systemName: icon)
            Text(title)
        }
        .padding()
        .frame(width: 150, height: 100)
        .background(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.8), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
            )
        )
        
        
    }
    
}
