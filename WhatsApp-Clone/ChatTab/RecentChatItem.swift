//
//  RecentChatItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 1/7/24.
//

import SwiftUI

struct RecentChatItem: View {
    let channel: ChannelItem
    var body: some View {
        HStack(alignment: .top) {
            Circle()
                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text(channel.name ?? "Unknown")
                Text(channel.lastMessage)
                .font(.caption)
                .foregroundStyle(.gray)
            }
            Spacer()
            Text("Yesterday")
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    RecentChatItem(channel: .placeholder)
}
