//
//  BubbleTextView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI

struct BubbleTextView: View {
    let item: MessageBubbleItem
    var body: some View {
        Text("Hello, World! How are you?")
            .padding(10)
            .background(item.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .applyTail(item.direction)
    }
}

#Preview {
    ScrollView {
        BubbleTextView(item: .sentPlaceholder)
        BubbleTextView(item: .receivedPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(Color.gray.opacity(0.1))
}
