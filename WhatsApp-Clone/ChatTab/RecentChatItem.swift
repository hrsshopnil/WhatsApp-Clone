//
//  RecentChatItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 1/7/24.
//

import SwiftUI

struct RecentChatItem: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text("Walter White")
                Text("welcome")
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
    RecentChatItem()
}
