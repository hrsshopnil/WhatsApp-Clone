//
//  TextFieldView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 7/7/24.
//

import SwiftUI

struct TextFieldView: View {
    var image: String
    var placeHolder: String
    var isPassword: Bool
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: image)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 30)
            if isPassword {
                SecureField(placeHolder, text: $text)
            } else {
                TextField(placeHolder, text: $text)
            }
        }
        .padding()
        .background(.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    TextFieldView(image: "envelope", placeHolder: "email", isPassword: true, text: .constant(""))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.teal)
}
