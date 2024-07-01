//
//  ChannelListView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 30/6/24.
//

import SwiftUI

struct ChannelListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stay updated on topics that matter to you. Find channels to follow bellow.")
                .font(.callout)
                .foregroundStyle(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<5) {_ in 
                        ChannelListItem()
                    }
                }
            }
            Button {
                
            } label: {
                Text("Explore more")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        .link
                    )
                    .clipShape(Capsule())
            }
            .padding(.top, 5)

        }
    }
}

#Preview {
    ChannelListView()
}
