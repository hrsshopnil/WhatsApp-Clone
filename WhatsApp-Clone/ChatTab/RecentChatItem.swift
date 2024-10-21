//
//  RecentChatItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 1/7/24.
//

import SwiftUI

struct RecentChatItem: View {
    
    let channel: ChannelItem
    var image: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            CircularProfileImageView(channel, size: .medium)
            
            VStack(alignment: .leading) {
                Text(channel.name ?? "Unknown")
                HStack(spacing: 4) {
                    if channel.lastMessageType != .text {
                        Image(systemName: channel.previewIcon)
                            .imageScale(.small)
                    }
                    Text(channel.previewMessage)
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            Spacer()
            Text(channel.lastMessageTimeStamp.dayOrTimeRepresentation)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        
    }
}

#Preview {
    RecentChatItem(channel: .placeholder)
}
