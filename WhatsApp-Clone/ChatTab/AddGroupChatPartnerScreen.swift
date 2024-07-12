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
            Section {
                ForEach(0..<12) {_ in
                    chatPartnerSelectView(.placeHolder)
                }
            }
        }
        .searchable(text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search name or number")
    }
    
    private func chatPartnerSelectView(_ user: UserItem) -> some View {
        ChatPartnerRowView(user: user) {
            Spacer()
            Image(systemName: "circle")
                .foregroundStyle(.gray)
                .imageScale(.large)
        }
    }
}

#Preview {
    AddGroupChatPartnerScreen(viewModel: ChatPartnerPickerViewModel())
}
