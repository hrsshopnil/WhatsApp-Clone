//
//  BubbleView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 20/8/24.
//

import SwiftUI

struct BubbleView: View {
    
    let message: MessageItem
    let channel: ChannelItem
    let isNewDay: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isNewDay {
                newDayTimeStampTextView()
                    .padding()
            }
            composeDynamicBubbleView()
        }
    }
    
    @ViewBuilder
    private func composeDynamicBubbleView() -> some View {
        switch message.type {
        case .admin(let messageType):
            switch messageType {
                
            case .channelCreation:
                newDayTimeStampTextView()
                ChannelCreationTextView()
                    .padding()
                if channel.isGroupChat {
                    AdminTextView(channel: channel)
                }
                
            default:
                Text("ADMIN TEXT")
            }
            
        case .text:
            BubbleTextView(item: message)
        case .photo, .video:
            BubblePhotoView(item: message)
        case .audio:
            BubbleAudioView(item: message)
        }
    }
    
    private func newDayTimeStampTextView() -> some View {
        Text(message.timeStamp.relativeDateString)
            .font(.caption)
            .bold()
            .padding(.vertical, 3)
            .padding(.horizontal)
            .background(.whatsAppGray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BubbleView(message: .sentPlaceholder, channel: .placeholder, isNewDay: false)
}
