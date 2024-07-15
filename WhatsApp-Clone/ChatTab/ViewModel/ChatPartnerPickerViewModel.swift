//
//  ChatPartnerPickerViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation

enum ChatCreationRoute {
    case addGroupChatMember, setUpGroup
}
enum ChannelConstants {
    static let maxGroupParticipants = 12
}

@MainActor
final class ChatPartnerPickerViewModel: ObservableObject {
    @Published var navStack = [ChatCreationRoute]()
    @Published var selectedChatPartners = [UserItem]()
    @Published private(set) var users = [UserItem]()
    
    private var lastCursor: String?
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    var showSelectedUser: Bool {
        return !selectedChatPartners.isEmpty
    }
    
    var disableButton: Bool {
        return selectedChatPartners.isEmpty
    }
    
    var isPaginatable: Bool {
        return !users.isEmpty
    }
    
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            self.users.append(contentsOf: userNode.users)
            self.lastCursor = userNode.currentCursor
            print("LastCursor \(String(describing: lastCursor))")
        } catch {
            print("Failed to fetch user for chatpickerScreen ")
        }
    }
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            guard let index = selectedChatPartners.firstIndex(where: {$0.id == item.id}) else {return}
            selectedChatPartners.remove(at: index)
        } else {
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains {$0.id == user.id}
        return isSelected
    }
}
