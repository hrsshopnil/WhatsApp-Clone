//
//  ReactionPickerView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 27/8/24.
//

import SwiftUI

struct EmojiReaction {
    let reaction: Reaction
    var isAnimating = false
    var opacity: CGFloat = 1
}
struct ReactionPickerView: View {
    
    @State private var emojiState: [EmojiReaction] = [
        EmojiReaction(reaction: .like),
        EmojiReaction(reaction: .love),
        EmojiReaction(reaction: .laugh),
        EmojiReaction(reaction: .shocked),
        EmojiReaction(reaction: .sad),
        EmojiReaction(reaction: .pray),
        EmojiReaction(reaction: .more)
    ]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(emojiState.enumerated()), id: \.offset) {index, item in
                Text(item.reaction.emoji)
                    .font(.system(size: 30))
            }
        }
    }
}

#Preview {
    ReactionPickerView()
}
