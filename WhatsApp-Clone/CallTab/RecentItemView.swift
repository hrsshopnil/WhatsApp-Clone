//
//  RecentItemView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 30/6/24.
//

import SwiftUI

struct RecentItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text("Walter White")
                HStack {
                    Image(systemName: "phone.arrow.up.right.fill")
                    Text("Outgoing")
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            Spacer()
            Text("Yesterday")
                .font(.callout)
                .foregroundStyle(.gray)
            Image(systemName: "info.circle")
                .imageScale(.large)
        }
    }
}

#Preview {
    RecentItemView()
}
