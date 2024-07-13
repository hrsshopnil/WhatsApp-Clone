//
//  SelectedPartnerView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 13/7/24.
//

import SwiftUI

struct SelectedPartnerView: View {
    let users: [UserItem]
    let onTabHandler: (_ user: UserItem) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(users) {item in
                    VStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(.gray)
                            .overlay(alignment: .topTrailing) {
                                Button{
                                   onTabHandler(item)
                                }
                            label: {
                                Image(systemName: "xmark")
                                    .imageScale(.small)
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color(.systemGray2))
                                    .clipShape(Circle())
                            }
                            }
                        Text(item.username)
                    }
                }
            }
        }
    }
}

#Preview {
    SelectedPartnerView(users: UserItem.placeHolders) {user in
        
    }
}
