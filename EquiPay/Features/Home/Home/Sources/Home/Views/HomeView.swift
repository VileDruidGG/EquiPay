//
//  HomeView.swift
//  Home
//
//  Created by Christofher Ontiveros Espino on 15/10/25.
//
import SwiftUI
import DesignSystem

public struct HomeView: View {
    
    @State private var username = "Paco"
    
    public init() {
        
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Hola \(username)").font(.largeTitle).bold()
                        Text("Manage your shared expenses")
                    }
                    ZStack{
                        Image("profile")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .clipShape(Circle())
                        Button(action: {
                            print("+ pressed")
                        }) {
                            Image(systemName: "plus").foregroundColor(Color.white)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.2))
                            )
                    )

                    
                }
                HStack{
                    SummaryCard(
                        title: "They owe you",
                        amount: "$450",
                        icon: "dollarsign",
                        color: Color.green)
                    SummaryCard(
                        title: "You owe",
                        amount: "$450",
                        icon: "dollarsign",
                        color: Color.red)
                    SummaryCard(
                        title: "Active Groups",
                        amount: "3",
                        icon: "person.3.fill",
                        color: Color.purple)
                    
                }.padding()
            }.frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.6)
                .background(LinearGradient(colors: [Color.mint, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        VStack{
            HStack{
                Text("Recent Expenses").font(.title)
                Spacer()
                Button{
                    print("Settings pressed")
                } label: {
                    Text("See All")
                    Image(systemName: "chevron.right")
                }
                
            }
            
            ExpenseCard(icon: "person.3.fill", title: "Viaje de fin de año", participantsAmount: 10, amount: "2790", status: ExpenseStatus.paid)
            ExpenseCard(icon: "arrow.trianglehead.2.clockwise.rotate.90", title: "Viaje de fin de año", participantsAmount: 10, amount: "2790", status: ExpenseStatus.paid)
            ExpenseCard(icon: "bag", title: "Viaje de fin de año", participantsAmount: 10, amount: "2790", status: ExpenseStatus.paid)
            
            Text("Quick Access").font(.title)
            HStack{
                QuickActionCard(title: "Create group", icon: "plus", isPrincipal: true)
                QuickActionCard(title: "Ver historial", icon: "clock", isPrincipal: false)
                
            }
            Spacer()
        }.padding(.horizontal, 20)
        
    }
}

#Preview {
    HomeView()
}
