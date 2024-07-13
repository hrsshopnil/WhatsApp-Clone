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
                ForEach(UserItem.placeHolders) {item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatPartnerSelectView(item)
                    }
                }
            }
        }
        .animation(.easeInOut, value: viewModel.showSelectedUser)
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search name or number")
    }
    
    private func chatPartnerSelectView(_ user: UserItem) -> some View {
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
}

#Preview {
    GroupPartnerPickerScreen(viewModel: ChatPartnerPickerViewModel())
}
