//
//  SignUpView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI
import DesignSystem

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    public var body: some View {
        VStack {
            // Header
            Text("Let´s create an account").font(.title.bold()).foregroundStyle(LinearGradient(colors: [.mint, .purple],  startPoint: .leading, endPoint: .trailing))
            
            //Subheader
            Text("Joins to start sharing and saving")
                .font(.headline.bold())
                .foregroundColor(.secondary).padding(.bottom, 20)
            
            //Form
            EmailInput(email: "dfsdf", isValidEmail: true)
            HStack{
                Image(systemName: "person.fill")
                TextField("Full name", text: $username)
                
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password", text: $password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Confirm password", text: $password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            
            //Navigation
            PrimaryButton("Sign Up") {
                print("Go to Home")
            }.padding(.top, 20)
            
            HStack{
                Text("Already have an account?")
                Button(action: {}) {
                    Text("Log In")
                }
            }
           
            
            
        }.padding(.horizontal, 18)
    }

}
#Preview {
    SignUpView()
}
