//
//  ChatPartnerPickerScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct ChatPartnerPickerScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @StateObject private var viewModel = ChatPartnerPickerViewModel()
    var body: some View {
        NavigationStack(path: $viewModel.navStack) {
            List {
                ForEach(ChatPartnerPickerOption.allCases) {item in
                    Button {
                        guard item == ChatPartnerPickerOption.newGroup else {return}
                        viewModel.navStack.append(.addGroupChatMember)
                    }
                label:{
                    HStack {
                        IconWithTransparentBG(imageName: item.imageName)
                        Text(item.title)
                    }
                }
                }
                Section {
                    ForEach(viewModel.users) { user in
                        ChatPartnerRowView(user: user)
                    }
                } header: {
                    Text("Contact on Whatsapp")
                        .fontWeight(.semibold)
                        .textCase(.none)
                }
                
                if viewModel.isPaginatable {
                    loadMoreMessage()
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search name or number")
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChatCreationRoute.self) { route in
                destinationView(for: route)
            }
            .toolbar{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                        .foregroundStyle(.black.opacity(0.6))
                        .bold()
                        .padding(10)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    
    private func loadMoreMessage() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}
extension ChatPartnerPickerScreen {
    @ViewBuilder
    private func destinationView(for route: ChatCreationRoute) -> some View {
        switch route {
            
        case .addGroupChatMember:
            GroupPartnerPickerScreen(viewModel: viewModel)
        case .setUpGroup:
            SetUpGroupView(viewModel: viewModel)
        }
    }
}

#Preview {
    ChatPartnerPickerScreen()
}
