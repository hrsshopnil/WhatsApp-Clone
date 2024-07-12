//
//  AddGroupChatPartnerScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct AddGroupChatPartnerScreen: View {
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    @State private var searchText = ""
    var body: some View {
        List {
            if viewModel.showSelectedUser {
                Text("aldsfkalkdf")
            }
            Section {
                ForEach([UserItem.placeHolder]) {item in
                    Button {
                        viewModel.handleItemSelection(item)
                    } label: {
                        chatPartnerSelectView(.placeHolder)
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
    AddGroupChatPartnerScreen(viewModel: ChatPartnerPickerViewModel())
}
