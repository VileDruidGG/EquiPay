//
//  HomeView.swift
//  Home
//
//  Created by Christofher Ontiveros Espino on 15/10/25.
//
import SwiftUI

public struct HomeView: View {
    
    @State private var username = "Paco"
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Hola \(username)").font(.largeTitle)
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
                            Image(systemName: "plus")
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(21)
                    
                }
                HStack{
                    Text("Expenses")
                    
                }
            }.frame(maxWidth: .infinity, maxHeight: geometry.size.height * 0.3)
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
            Text("Quick Access").font(.title)
            HStack{
                
                
            }
            Spacer()
        }.padding(.horizontal, 20)
        
    }
}

#Preview {
    HomeView()
}
