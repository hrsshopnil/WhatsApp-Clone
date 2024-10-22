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
            VStack(alignment: .trailing) {
                Text(channel.lastMessageTimeStamp.dayOrTimeRepresentation)
                    .font(.caption)
                    .foregroundStyle(.gray)
                if channel.unreadCount > 0 {
                    badgeView(count: channel.unreadCount)
                }
            }
            
        }
        
    }
    
    private func badgeView(count: Int) -> some View {
        Text(count.description)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(.badge)
            .bold()
            .font(.caption)
            .clipShape(Capsule())
    }
}

#Preview {
    RecentChatItem(channel: .placeholder)
}
