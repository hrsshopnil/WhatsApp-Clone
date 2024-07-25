//
//  ChatPartnerPickerViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation
import Firebase

enum ChatCreationRoute {
    case addGroupChatMember, setUpGroup
}
enum ChannelCreationError: Error {
    case noParticipant, failedToCreateUniqueID
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
            var fetchedUsers = userNode.users
            guard let currentId = Auth.auth().currentUser?.uid else {return}
            fetchedUsers = fetchedUsers.filter {$0.id != currentId}
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
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
    
     func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else {return .failure(ChannelCreationError.noParticipant)}
        
        guard
            let channelID = FirebaseConstants.ChannelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid,
            let messageId = FirebaseConstants.MessageRef.childByAutoId().key
        else {return .failure(ChannelCreationError.failedToCreateUniqueID)}
        
        let timeStamp = Date().timeIntervalSince1970
        var memberUids = selectedChatPartners.compactMap {$0.id}
        
        memberUids.append(currentUid)
        
        var channelDict: [String: Any] = [
            .id: channelID,
            .lastMessage: "",
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .membersUids: memberUids,
            .membersCount: memberUids.count,
            .adminUids: [currentUid]
        ]
        
        if let safeChannelName = channelName, !safeChannelName.isEmptyOrWhiteSpaces {
            channelDict[.name] = safeChannelName
        }
        
        FirebaseConstants.ChannelsRef.child(channelID).setValue(channelDict)
        
        memberUids.forEach { userId in
            ///keeping an index of the channel that a specific user belong to
            FirebaseConstants.UserChannelRef.child(userId).child(channelID).setValue(true)
            ///makes sure that a direct channel is unique
            FirebaseConstants.UserDirectChannels.child(userId).child(channelID).setValue(true)
        }
        
        let newChannelItem = ChannelItem(dict: channelDict)
        return .success(newChannelItem)
    }
}
