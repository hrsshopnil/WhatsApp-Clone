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
                    ForEach(0..<20) { _ in
                        ChatPartnerRowView(user: .placeHolder)
                    }
                } header: {
                    Text("Contact on Whatsapp")
                        .fontWeight(.semibold)
                        .textCase(.none)
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
}

extension ChatPartnerPickerScreen {
    @ViewBuilder
    private func destinationView(for route: ChatCreationRoute) -> some View {
        switch route {
            
        case .addGroupChatMember:
            AddGroupChatPartnerScreen(viewModel: viewModel)
        case .setUpGroup:
            Text("Set Up Chat Group")
        }
    }
}
enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newChat = "New Contact"
    case addToContact = "New Community"
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        return rawValue
    }
    
    var imageName: String {
        switch self {
            
        case .newGroup:
            return "person.2.fill"
        case .newChat:
            return "person.fill.badge.plus"
        case .addToContact:
            return "person.3.fill"
        }
    }
}
#Preview {
    ChatPartnerPickerScreen()
}