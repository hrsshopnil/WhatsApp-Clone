//
//  MessageReactionView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/8/24.
//

import SwiftUI

struct MessageReactionView: View {
    
    let message: MessageItem
    let emojis = ["👍", "❤️", "😂", "😯"]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(emojis, id: \.self) { emoji in
                Text(emoji)
            }
            Text("3")
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

#Preview {
    ZStack {
        MessageReactionView(message: .sentPlaceholder)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
}
