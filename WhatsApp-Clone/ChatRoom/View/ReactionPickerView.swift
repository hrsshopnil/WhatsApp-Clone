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
    
    let message: MessageItem
    let onTap: ((_ selectedEmoji: Reaction) -> Void)
    
    @State private var animatingBgView = false
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
                reactionButton(item, at: index)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 0)
        .background(backgroundView())
        .onAppear {
            withAnimation(.easeIn(duration: 0.2)) {
                animatingBgView = true
            }
        }
    }
     
    private var springAnimatin: Animation {
        Animation.spring(
            response: 0.55, dampingFraction: 0.6, blendDuration: 0.05
        ).speed(4)
    }
    
    private func reactionButton(_ item: EmojiReaction, at index: Int) -> some View {
        Button {
            guard item.reaction != .more else { return }
            onTap(item.reaction)
        } label: {
            buttonLabel(item, at: index)
                .scaleEffect(emojiState[index].isAnimating ? 1 : 0.1)
                .onAppear {
                    let dynamicIndex = getAnimationIndex(index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(springAnimatin.delay(Double(dynamicIndex) * 0.05)) {
                            emojiState[index].isAnimating = true
                        }
                    }
                }
        }
    }
    
    private func getAnimationIndex(_ index: Int) -> Int {
        if message.direction == .sent {
            let reversedIndex = emojiState.count - 1 - index
            return reversedIndex
        } else {
            return index
        }
    }
    
    @ViewBuilder
    private func emojiButtonBg(_ reaction: Reaction) -> some View {
        if message.currentUserHasReacted, let userReaction = message.currentUserReaction, userReaction == reaction.emoji {
            Color(.systemGray5)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    private func buttonLabel(_ item: EmojiReaction, at index: Int) -> some View {
        if item.reaction == .more {
            Image(systemName: "plus")
                .bold()
                .foregroundStyle(.gray)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        } else {
            Text(item.reaction.emoji)
                .font(.system(size: 30))
                .background(emojiButtonBg(item.reaction))
        }
    }
    
    private func backgroundView() -> some View {
        Capsule()
            .fill(Color.contextMenuTint)
            .mask {
                Capsule()
                    .fill(Color.contextMenuTint)
                    .scaleEffect(animatingBgView ? 1 : 0, anchor: message.menuAnchor)
                    .opacity(animatingBgView ? 1 : 0)
            }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(.thinMaterial)
        ReactionPickerView(message: .sentPlaceholder) {_ in
            
        }
    }
}
