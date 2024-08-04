//
//  BubbleTextView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI

struct BubbleTextView: View {
    let item: MessageItem
    var body: some View {
        HStack(alignment: .bottom, spacing: 3) {
            if item.showSenderProfile {
                CircularProfileImageView(size: .mini, profileImageUrl: item.sender?.profileImageUrl)
            }
            if item.direction == .sent {
                TimeStampView(item: item)
            }
            Text(item.text)
                .padding(10)
                .background(item.bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .applyTail(item.direction)
            if item.direction == .received {
                TimeStampView(item: item)
            }
        }
        
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
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
