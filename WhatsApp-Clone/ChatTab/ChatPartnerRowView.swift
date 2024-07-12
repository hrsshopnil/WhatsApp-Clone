//
//  ChatPartnerRowView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct ChatPartnerRowView: View {
    let user: UserItem
    var body: some View {
        HStack {
            Button {
                
            } label: {
                HStack {
                    Circle()
                        .frame(width: 45, height: 45)
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .fontWeight(.semibold)
                        Text(user.bioUnwrapped)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    ChatPartnerRowView(user: .placeHolder)
}
