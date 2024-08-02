//
//  ChatPartnerRowView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct ChatPartnerRowView<Content: View>: View {
    private let user: UserItem
    private let trailingItem: Content
    
    init(user: UserItem, @ViewBuilder trailingItem: () -> Content = {EmptyView()}) {
        self.user = user
        self.trailingItem = trailingItem()
    }
    var body: some View {
        HStack {
            CircularProfileImageView(size: .xSmall, profileImageUrl: user.profileImageUrl)
                .frame(width: 45, height: 45)
            VStack(alignment: .leading) {
                Text(user.username)
                    .fontWeight(.semibold)
                Text(user.bioUnwrapped)
                    .font(.footnote)
                    .foregroundStyle(.gray)
            }
            trailingItem
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeHolder) {
        Text("hello")
            .foregroundStyle(.gray)
    }
}
