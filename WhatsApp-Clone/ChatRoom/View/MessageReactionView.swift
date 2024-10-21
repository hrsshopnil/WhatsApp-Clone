//
//  MessageReactionView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/8/24.
//

import SwiftUI

struct MessageReactionView: View {
    
    let message: MessageItem
    private var emojis: [String] {
        return message.reactions.map { $0.key }
    }
    
    private var emojiCount: Int {
        let stats = message.reactions.map { $0.value }
        return stats.reduce(0, +)
    }
    
    var body: some View {
        if message.hasReaction {
            HStack(spacing: 2) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                }
                if emojiCount > 1 {
                    Text(emojiCount.description)
                }
            }
            .fontWeight(.semibold)
            .font(.footnote)
            .padding(4)
            .padding(.horizontal, 2)
            .background(Capsule().fill(.thinMaterial))
            .overlay (
            Capsule()
                .stroke(message.bgColor, lineWidth: 2)
            )
            .shadow(color: message.bgColor.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}

#Preview {
    ZStack {
        MessageReactionView(message: .sentPlaceholder)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
}
