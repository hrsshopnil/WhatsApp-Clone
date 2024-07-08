//
//  RegisterView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 8/7/24.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var authScreenModel: AuthScreenModel
    var body: some View {
        VStack {
            Spacer()
            
            AuthHeaderView()
            TextFieldView(image: "envelope", placeHolder: "email", isPassword: false, text: $authScreenModel.email)
            TextFieldView(image: "at", placeHolder: "username", isPassword: false, text: $authScreenModel.username)
            TextFieldView(image: "lock", placeHolder: "password", isPassword: true, text: $authScreenModel.password)
            AuthButton(title: "Register") {
                //
            }
            .disabled(authScreenModel.disabledRegisterButton)
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
            .padding(.bottom, 25)

        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Gradient(colors: [.green, .teal]))
    }
}

#Preview {
    RegisterView(authScreenModel: AuthScreenModel())
}
