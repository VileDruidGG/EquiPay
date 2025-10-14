//
//  LoginView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25./Users/christofherontiverosespino/Documents/GitHub/EquiPay/EquiPay/Features/Auth/Auth/Sources/Auth/ViewModels/LoginViewModel.swift
//
import SwiftUI
import DesignSystem

public struct LoginView: View {
    
    @StateObject private var vm: LoginViewModel
    
    //Init público (estás en un package)
    public init(vm: LoginViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    public var body: some View {
        VStack {
            // Header
            Text("EquiPay").font(.largeTitle.bold()).foregroundStyle(LinearGradient(colors: [.mint, .purple],  startPoint: .leading, endPoint: .trailing))
            
            //Subheader
            Text("Fair splits. Smarter sharing.")
                .font(.headline.bold())
                .foregroundColor(.secondary).padding(.bottom, 20)
            
            //Form
            EmailInput(email: vm.email, isValidEmail: false)
//            HStack{
//                Image(systemName: "person.fill")
//                TextField("Email", text: $email)
//
//            }.padding(18)
//                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            HStack{
                Image(systemName: "lock.fill")
                SecureField("Password", text: $vm.password)
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            
            //Navigation
            PrimaryButton("Log In") {
                //TODO añadir validación real
                vm.login()
            }.padding(.top, 20)
            HStack{
                Text("Don't have an account?")
                Button("Sign Up"){vm.goToSignUp()}
            }
        }.padding(.horizontal, 18)
    }
}
