//
//  LoginView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI
import DesignSystem

public struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    public var body: some View {
        VStack {
            // Header
            Text("EquiPay").font(.largeTitle.bold()).foregroundStyle(LinearGradient(colors: [.mint, .purple],  startPoint: .leading, endPoint: .trailing))
            
            //Subheader
            Text("Fair splits. Smarter sharing.")
                .font(.headline.bold())
                .foregroundColor(.secondary).padding(.bottom, 20)
            
            //Form
            HStack{
                Image(systemName: "person.fill")
                TextField("Username", text: $username)
                
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password", text: $password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            
            //Navigation
            PrimaryButton("Log In") {
                print("Go to Home")
            }.padding(.top, 20)
            Button(action: {}) {
                Text("Already have an account?")
            }
            
            
        }.padding(.horizontal, 18)
    }
}



#Preview {
    LoginView()
}
