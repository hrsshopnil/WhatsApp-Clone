//
//  LoginView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 7/7/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                TextFieldView(image: "envelope", placeHolder: "email", isPassword: false, text: $email)
                TextFieldView(image: "lock", placeHolder: "password", isPassword: true, text: $password)
                forgotPassword()
                AuthButton(title: "Login") {
                    //
                }
                Spacer()
                signUpButton()
                    .padding(.bottom)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [.teal.opacity(0.6), .teal], startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
        }
    }
}

private func forgotPassword() -> some View {
    Button {
        
    } label: {
        Text("Forgot Password?")
            .font(.subheadline)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .bold()
    }
}

private func signUpButton() -> some View {
    NavigationLink {
        RegisterView()
    } label: {
        HStack {
            (
            Text("Don't have an account? ")
            +
            Text("Create one")
                .bold()
            )
        }
        .foregroundStyle(.white)
    }
}
#Preview {
    LoginView()
}
