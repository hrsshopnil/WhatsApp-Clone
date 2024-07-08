//
//  RegisterView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 8/7/24.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        VStack {
            Spacer()
            
            AuthHeaderView()
            TextFieldView(image: "envelope", placeHolder: "email", isPassword: false, text: $email)
            TextFieldView(image: "at", placeHolder: "username", isPassword: false, text: $username)
            TextFieldView(image: "lock", placeHolder: "password", isPassword: true, text: $password)
            AuthButton(title: "Register") {
                //
            }
            .padding(.top)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                (
                Text("Already have an account? ")
                +
                Text("Login").bold()
                )
                .foregroundStyle(.white)
            }

        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Gradient(colors: [.green, .teal]))
    }
}

#Preview {
    RegisterView()
}
