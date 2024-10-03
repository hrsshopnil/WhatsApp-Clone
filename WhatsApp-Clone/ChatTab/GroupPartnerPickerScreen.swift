//
//  AddGroupChatPartnerScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct GroupPartnerPickerScreen: View {
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    @State private var searchText = ""
    var body: some View {
        List {
            if viewModel.showSelectedUser {
                SelectedPartnerView(users: viewModel.selectedChatPartners) {user in
                    viewModel.handleItemSelection(user)
                }
            }
            
            Section {
                ForEach(viewModel.users) {item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatPartnerSelectionView(item)
                    }
                }
            }
            
            if viewModel.isPaginatable {
                laodMoreUser()
            }
            
        }
        .animation(.easeInOut, value: viewModel.showSelectedUser)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search name or number")
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("New Participants")
                    let count = viewModel.selectedChatPartners.count
//                    let maxCount = UserItem.placeHolders.count
                    Text("\(count)/\(12)")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Next") {
                    viewModel.navStack.append(.setUpGroup)
                }
                .disabled(viewModel.disableButton)
            }
        }
    }
    
    private func chatPartnerSelectionView(_ user: UserItem) -> some View {
        ChatPartnerRowView(user: user) {
            let isSelected = viewModel.isUserSelected(user)
            let imageName = isSelected ? "checkmark.circle.fill" : "circle"
            let color = isSelected ? Color.blue : Color.gray
            Spacer()
            Image(systemName: imageName)
                .foregroundStyle(color)
                .imageScale(.large)
        }
    }
    
    private func laodMoreUser() -> some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .task {
                await viewModel.fetchUsers()
            }
    }
}

#Preview {
    NavigationStack {
        GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
    }
}
