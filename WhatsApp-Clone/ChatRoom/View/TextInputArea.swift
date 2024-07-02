//
//  TextInputArea.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct TextInputArea: View {
    @State private var text = ""
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 20))
            buttonImage(image: "mic.fill")
            TextField("", text: $text, axis: .vertical)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.thinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
            
            buttonImage(image: "arrow.up")
        }
        .padding()
        .background(.whatsAppWhite)
    }
    
    private func buttonImage(image: String) -> some View {
        Image(systemName: image)
            .bold()
            .padding(5)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Circle())
    }
}

#Preview {
    TextInputArea()
}
