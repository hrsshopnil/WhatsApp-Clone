//
//  ChannelListItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 30/6/24.
//

import SwiftUI

struct ChannelListItem: View {
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .frame(width: 55, height: 55)
            Text("Real Madrid CF.")
                .font(.headline)
            
            Button {
                
            } label: {
                Text("Follow")
                    .bold()
                    .padding(5)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Capsule())
            }

        }
        .padding(.horizontal, 16)
        .padding(.vertical)
        .overlay(
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

#Preview {
    ChannelListItem()
}
