//
//  TextInputArea.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct TextInputArea: View {
    @Binding var textMessage: String
    @Binding var isRecording: Bool
    @Binding var timeInterval: TimeInterval
    @State private var isPulsing = false
    var disableButton: Bool
    
    let actionHandler: (_ action: UserAction) -> Void
    
    private var sendButtonDisabled: Bool {
        return disableButton || isRecording
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
        .disabled(isRecording)
        .grayscale(isRecording ? 0.8: 1)
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
        .disabled(sendButtonDisabled)
        .foregroundStyle(sendButtonDisabled ? .gray : .blue)
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .background(.whatsAppWhite)
        .animation(.spring, value: isRecording)
        .onChange(of: isRecording) { oldValue, isRecording in
            if isRecording {
                withAnimation(.easeIn(duration: 1.5).repeatForever()) {
                    isPulsing = true
                }
            } else {
                isPulsing = false
            }
        }
    }
    
    private func audioButton() -> some View {
        Button {
            actionHandler(.recordingAudio)
        }
    label: {
        Image(systemName: isRecording ? "square.fill" : "mic.fill")
            .bold()
            .padding(6)
            .foregroundStyle(.white)
            .background(isRecording ? .red : .blue)
            .clipShape(Circle())
    }
    }
    
    private func audioRecordingIndicator() -> some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.callout)
                .foregroundStyle(.red)
                .scaleEffect(isPulsing ? 1.5 : 0.8)
            
            Text("Recording Audio")
                .font(.callout)
                .lineLimit(1)
            Spacer()
            
            Text(timeInterval.formattedElapsedTime)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
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
        case presentPhotoPicker, sendMessage, recordingAudio
    }
}
#Preview {
    TextInputArea(textMessage: .constant(""), isRecording: .constant(false), timeInterval: .constant(0), disableButton: false)  { action in
        
    }
}
