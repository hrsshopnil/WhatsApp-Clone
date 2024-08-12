//
//  TextInputArea.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    @State private var isRecording = false
    
    let actionHandler: (_ action: UserAction) -> Void
    
    private var disableButton: Bool {
        return textMessage.isEmptyOrWhiteSpaces
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            ///Gallery Button
            Button {
                actionHandler(.presentPhotoPicker)
            }
        label: {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
        }
            audioButton()
            
            if isRecording {
                audioRecordingIndicator()
            } else {
                textFielldView()
            }
            ///Send Button
            Button {
                actionHandler(.sendMessage)
            }
        label: {
            Image(systemName: "paperplane.fill")
                .font(.system(size: 24))
                .padding(.bottom, 3)
        }
        .disabled(disableButton)
        .foregroundStyle(disableButton ? .gray : .blue)
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .background(.whatsAppWhite)
    }
    
    private func audioButton() -> some View {
        Button {
            isRecording.toggle()
        }
    label: {
        Image(systemName: "mic.fill")
            .bold()
            .padding(5)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(Circle())
    }
    }
    
    private func audioRecordingIndicator() -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.callout)
                .foregroundStyle(.red)
            
            Text("Recording Audio")
                .font(.callout)
                .lineLimit(1)
            Spacer()
            
            Text("00:02")
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.blue.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    
    private func textFielldView() -> some View {
        TextField("", text: $textMessage, axis: .vertical)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color(.systemGray5), lineWidth: 1)
            )
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
