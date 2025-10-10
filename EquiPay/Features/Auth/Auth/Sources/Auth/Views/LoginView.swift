//
//  LoginView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI
import DesignSystem

public struct LoginView: View {
    
    @State private var email: String = ""
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
            EmailInput(email:"fsdf", isValidEmail: false)
//            HStack{
//                Image(systemName: "person.fill")
//                TextField("Email", text: $email)
//
//            }.padding(18)
//                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password", text: $password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            
            //Navigation
            PrimaryButton("Log In") {
                print("Go to Home")
            }.padding(.top, 20)
            HStack{
                Text("Don't have an account?")
                Button(action: {}) {
                    Text("Sign Up")
                }
            }
            
            
        }.padding(.horizontal, 18)
    }
}



#Preview {
    LoginView()
}
