//
//  ChatRoomView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct ChatRoomView: View {
    let channel: ChannelItem
    var body: some View {
        MessageListView()
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Circle()
                        .frame(width: 35, height: 35)
                    Text(channel.name ?? "Unknown")
                        .bold()
                }
            }
            
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Image(systemName: "video")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "phone")
                }
            }
            
        }
    }
}



#Preview {
    NavigationStack {
        ChatRoomView(channel: .placeholder)
    }
}
