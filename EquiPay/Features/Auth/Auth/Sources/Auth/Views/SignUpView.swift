//
//  SignUpView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI
import DesignSystem

struct SignUpView: View {
 
    @StateObject private var vm: SignUpViewModel
    
    //Init público (estás en un package)
    public init (vm: SignUpViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    public var body: some View {
        VStack {
            // Header
            Text("Let's create an account").font(.title.bold()).foregroundStyle(LinearGradient(colors: [.mint, .purple],  startPoint: .leading, endPoint: .trailing))
            
            //Subheader
            Text("Join to start sharing and saving")
                .font(.headline.bold())
                .foregroundColor(.secondary).padding(.bottom, 20)
            
            //Form
            EmailInput(email: vm.email, isValidEmail: true)
            HStack{
                Image(systemName: "person.fill")
                TextField("Full name", text: $vm.fullName)
                
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password", text: $vm.password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Confirm password", text: $vm.confirmPassword)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            
            //Navigation
            PrimaryButton("Sign Up") {
                vm.signup()
            }.padding(.top, 20)
            
            HStack{
                Text("Already have an account?")
                Button("Log In"){vm.goToLogin()}
            }
           
            
            
        }.padding(.horizontal, 18)
    }

}

