//
//  LoginView.swift
//  Auth
//
//  Created by Christofher Ontiveros Espino on 08/10/25.
//
import SwiftUI
import DesignSystem

public struct LoginView: View {
    
    // Acciones inyectadas desde el coordinator
    private let onSignUpTap: () -> Void
    private let onSucces: () -> Void
    
    // Estado local
    @State private var email: String = ""
    @State private var password: String = ""
    
    //Init público (estás en un package)
    public init(
        onSignUpTap: @escaping () -> Void,
        onSucces: @escaping () -> Void
    ) {
        self.onSignUpTap = onSignUpTap
        self.onSucces = onSucces
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
            EmailInput(email:email, isValidEmail: false)
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
                //TODO añadir validación real
                onSucces()
            }.padding(.top, 20)
            HStack{
                Text("Don't have an account?")
                Button(action: onSignUpTap) {
                    Text("Sign Up")
                }
            }
        }.padding(.horizontal, 18)
    }
}



#Preview {
    LoginView(
        onSignUpTap: {print("Go to sign up")}, onSucces: {print("login success")}
    )
}
