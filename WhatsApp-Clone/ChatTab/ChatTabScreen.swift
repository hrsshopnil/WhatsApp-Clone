//
//  ChatTabScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 1/7/24.
//

import SwiftUI

struct ChatTabScreen: View {
    @State private var searchText = ""
    @StateObject private var viewModel = ChannelTabViewModel()
    var body: some View {
        NavigationStack {
            List {
                Label("Archived", systemImage: "archivebox.fill")
                    .bold()
                    .foregroundStyle(.gray)
                
                ForEach(0..<2) {_ in
                    NavigationLink {
                        ChatRoomView()
                    } label: {
                        RecentChatItem()
                    }
                }
                
                HStack {
                    Image(systemName: "lock.fill")
                    
                    (
                        Text("Your personal message are")
                        +
                        Text("end-to-end encrypted")
                            .foregroundStyle(.blue)
                    )
                }
                .listRowSeparator(.hidden)
                .foregroundStyle(.gray)
                .font(.caption)
                .padding(.horizontal)
            }
            .sheet(isPresented: $viewModel.showChatPartnerPickerView) {
                ChatPartnerPickerScreen(onCreate: viewModel.onNewChannelCreation)
            }
            .navigationDestination(isPresented: $viewModel.navigateToChatRoom) {
                if viewModel.newChannel != nil {
                    ChatRoomView()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Selected Chats", systemImage: "checkmark.circle")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
                ToolbarItemGroup {
                    Button {
                        
                    } label: {
                        Image(.circle)
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "camera")
                    }
                    Button {
                        viewModel.showChatPartnerPickerView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    ChatTabScreen()
}
