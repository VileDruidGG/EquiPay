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
            Image(systemName: icon).foregroundColor(isPrincipal ? Color.white: Color.black)
            Text(title).foregroundColor(isPrincipal ? Color.white: Color.black).bold()
        }
        .padding()
        .frame(width: 150, height: 100)
        .background(RoundedRectangle(cornerRadius: 16)
            .stroke(Color.gray.opacity(0.8), lineWidth: isPrincipal ? 0:1)
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(isPrincipal ?
                      AnyShapeStyle( LinearGradient(colors: [Color.mint, Color.purple],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing))
                      : AnyShapeStyle( Color.white))
            )
        )
        
        
    }
    
}
