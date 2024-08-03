//
//  ChatRoomView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct ChatRoomView: View {
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    var body: some View {
        MessageListView(viewModel)
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            TextInputArea(textMessage: $viewModel.textMessage) {
                viewModel.sendMessage()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    CircularProfileImageView(channel, size: .mini)
                        .frame(width: 35, height: 35)
                    Text(channel.title)
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
