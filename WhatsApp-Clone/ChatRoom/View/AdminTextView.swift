//
//  AdminTextView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/8/24.
//

import SwiftUI

struct AdminTextView: View {
    let channel: ChannelItem
    var body: some View {
        VStack {
            if channel.isCreatedByMe {
                textView("You created this group. Tap to add new\n members")
            } else {
                textView("\(channel.creatorName) created this channel")
                textView("\(channel.creatorName) added you to this channel")
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func textView(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(8)
            .padding(.horizontal, 5)
            .background(.bubbleWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
    }
}

#Preview {
    ZStack{
        Color.gray.opacity(0.5)
        AdminTextView(channel: .placeholder)
            .ignoresSafeArea(.all)
    }
}
