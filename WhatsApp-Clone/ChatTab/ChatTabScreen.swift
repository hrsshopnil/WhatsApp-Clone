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
        NavigationStack(path: $viewModel.navRouts) {
            List {
                Label("Archived", systemImage: "archivebox.fill")
                    .bold()
                    .foregroundStyle(.gray)
                
                ForEach(viewModel.channels) {channel in
                    Button {
                        viewModel.navRouts.append(.chatRoom(channel))
                    } label: {
                        RecentChatItem(channel: channel)
                    }
                }
                HStack {
                    Image(systemName: "lock.fill")
                    
                    (
                        Text("Your personal message are ")
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
                if let newChannel = viewModel.newChannel {
                    ChatRoomView(channel: newChannel)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Chat")
            .searchable(text: $searchText)
            .navigationDestination(for: ChannelTabRouts.self) { route in
                destinationView(for: route)
            }
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

extension ChatTabScreen {
    @ViewBuilder
    private func destinationView(for route: ChannelTabRouts) -> some View {
        switch route {
        case .chatRoom(let channel):
            ChatRoomView(channel: channel)
        }
    }
}
#Preview {
    ChatTabScreen()
}
