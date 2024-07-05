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
        VStack(alignment: item.horizontalAlignment, spacing: 3) {
            Text("Hello, World! How are you?")
                .padding(10)
                .background(item.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .applyTail(item.direction)
            
            TimeStampView(item: item)
        }
        
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .received ? 5 : 100)
        .padding(.trailing, item.direction == .received ? 100 : 5)
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