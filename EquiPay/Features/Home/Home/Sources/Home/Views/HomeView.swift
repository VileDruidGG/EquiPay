//
//  HomeView.swift
//  Home
//
//  Created by Christofher Ontiveros Espino on 15/10/25.
//
import SwiftUI
import DesignSystem

public struct HomeView: View {
    
    @State public var username = "Paco"
    
    public init() {
        
    }
    
    public var body: some View {
        
        ScrollView(showsIndicators: false){
            VStack(spacing: 0){
                //HEADER
                headerSection
                    .background(
                        LinearGradient(
                            colors: [Color.mint, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.primary)
                    .padding(.bottom, 16)
                
                //CONTENT
                contentSection
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .top)
        
    }
    
    //MARK: Subviews
    @MainActor
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16){
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 4){
                    Text("Hola \(username)").font(.largeTitle).bold().foregroundColor(Color.white)
                    Text("Manage your shared expenses").foregroundColor(Color.white)
                }
                
                Spacer()
                
                Button(action: {
                    print("+ pressed")
                }) {
                    Image(systemName: "plus")
                        .font(.body.bold())
                        .foregroundColor(.white)
                        .padding(15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    )
                            )
                    }
            }
            
            // Cards resumen
                    HStack(spacing: 12) {
                        SummaryCard(
                            title: "They owe you",
                            amount: "$450",
                            icon: "dollarsign",
                            color: .green
                        )

                        SummaryCard(
                            title: "You owe",
                            amount: "$450",
                            icon: "dollarsign",
                            color: .red
                        )

                        SummaryCard(
                            title: "Active Groups",
                            amount: "3",
                            icon: "person.3.fill",
                            color: .purple
                        )
                    }
        }
        .padding(.top, 60)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    @MainActor
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 24){
            // Recent Expenses header
            HStack {
                Text("Recent Expenses")
                    .font(.title2.bold())
                
                Spacer()
                
                Button {
                    print("See all pressed")
                } label: {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                    }
                }
            }
            
            VStack(spacing: 12) {
                   ExpenseCard(
                       icon: "person.3.fill",
                       title: "Viaje de fin de año",
                       participantsAmount: 10,
                       amount: "2790",
                       status: .paid
                   )
                   ExpenseCard(
                       icon: "arrow.trianglehead.2.clockwise.rotate.90",
                       title: "Cena viernes",
                       participantsAmount: 4,
                       amount: "680",
                       status: .paid
                   )
                   ExpenseCard(
                       icon: "bag",
                       title: "Super de la casa",
                       participantsAmount: 3,
                       amount: "1240",
                       status: .paid
                   )
               }
            
            VStack(alignment: .leading, spacing: 12) {
                     Text("Quick Access")
                         .font(.title2.bold())

                HStack(alignment: .center, spacing: 12) {
                         QuickActionCard(
                             title: "Create group",
                             icon: "plus",
                             isPrincipal: true
                         )

                         QuickActionCard(
                             title: "Ver historial",
                             icon: "clock",
                             isPrincipal: false
                         )
                     }
                 }
            
            Spacer(minLength: 40)
        }
    }
    
}







#Preview {
    HomeView()
}
