//
//  TextInputArea.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    let actionHandler: (_ action: UserAction) -> Void
    
    private var disableButton: Bool {
        return textMessage.isEmptyOrWhiteSpaces
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            Button {
                actionHandler(.presentPhotoPicker)
            }
        label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 22))
            }
            buttonImage(image: "mic.fill")
            TextField("", text: $textMessage, axis: .vertical)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.thinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
            Button {
                actionHandler(.sendMessage)
            }
        label: {
            buttonImage(image: "arrow.up")
        }
        .disabled(disableButton)
        .grayscale(disableButton ? 0.8 : 0)
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

extension TextInputArea {
    enum UserAction {
        case presentPhotoPicker, sendMessage
    }
}
#Preview {
    TextInputArea(textMessage: .constant(""))  { action in
        
    }
}
