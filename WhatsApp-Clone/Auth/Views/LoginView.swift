//
//  LoginView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 7/7/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authScreenModel = AuthScreenModel()
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                AuthHeaderView()
                TextFieldView(image: "envelope", placeHolder: "email", isPassword: false, text: $authScreenModel.email)
                TextFieldView(image: "lock", placeHolder: "password", isPassword: true, text: $authScreenModel.password)
                forgotPassword()
                AuthButton(title: "Login") {
                    //
                }
                .disabled(authScreenModel.disabledLoginButton)
                Spacer()
                signUpButton()
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [.teal.opacity(0.6), .teal], startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .alert(isPresented: $authScreenModel.errorstate.showError) {
                Alert(
                    title: Text(authScreenModel.errorstate.errorMessage),
                    dismissButton: .default(Text("Ok"))
                )
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
            RegisterView(authScreenModel: authScreenModel)
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
}
#Preview {
    LoginView()
}
