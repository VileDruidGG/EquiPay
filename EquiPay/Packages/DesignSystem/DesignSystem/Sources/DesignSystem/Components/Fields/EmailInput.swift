//
//  EmailInput.swift
//  DesignSystem
//
//  Created by Christofher Ontiveros Espino on 10/10/25.
//
import SwiftUI


public struct EmailInput: View {
    
    @State private var email: String = ""
    @State private var isValidEmail: Bool = true
    
    public init(email: String, isValidEmail: Bool) {
        self.email = email
        self.isValidEmail = isValidEmail
    }
    
    public var body: some View {
        VStack{
            HStack{
                Image(systemName: "envelope.fill")
                TextField("Email", text: $email).keyboardType(.emailAddress).disableAutocorrection(true).autocapitalization(.none)//añadir el onChanged
            }.padding(18)
                .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            if !isValidEmail {
                Text("Invalid email format").foregroundColor(.red)
            }
        }
        
        
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
