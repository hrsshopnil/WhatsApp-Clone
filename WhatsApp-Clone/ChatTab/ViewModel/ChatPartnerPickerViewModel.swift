//
//  ChatPartnerPickerViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation
import Firebase
import Combine

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
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh oh")
    
    private var currentUser: UserItem?
    private var subscription: AnyCancellable?
    private var lastCursor: String?
    
    init() {
        listenToAuthState()
    }
    
    deinit {
        subscription?.cancel()
        subscription = nil
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
    
//    private func name(_ channelName: String?) -> String {
//        if let safeChannelName = channelName, !safeChannelName.isEmptyOrWhiteSpaces {
//            return safeChannelName
//        } else {
//            return title
//        }
//    }
    
    private func listenToAuthState() {
        subscription = AuthManager.shared.authstate.receive(on: DispatchQueue.main).sink { [weak self] authState in
            switch authState {
            case .loggedin(let loggedInUser):
                self?.currentUser = loggedInUser
                Task {
                    await self?.fetchUsers()
                }
            default:
                break
            }
        }
    }
    
    var isDirectchannel: Bool {
        return selectedChatPartners.count == 1
    }
    
    private var isGroupChat: Bool {
        return selectedChatPartners.count > 1
    }
    
    private var membersExcludingMe: [UserItem] {
        guard let currentId = Auth.auth().currentUser?.uid else { return [] }
        return selectedChatPartners.filter {$0.id != currentId}
    }
    
//    var title: String {
//        if isGroupChat {
//            return groupMemberNames
//        } else {
//            return membersExcludingMe.first?.username ?? "Unknown"
//        }
//    }
    
    private var groupMemberNames: String {
        let membmersCount = membersExcludingMe.count
        let fullNames: [String] = membersExcludingMe.map { $0.username }
        
        if membmersCount == 2 {
            return fullNames.joined(separator: " and ")
        } else if membmersCount > 2 {
            let remainingCount = membmersCount - 2
            return fullNames.prefix(2).joined(separator: ", ") + ", and \(remainingCount) others"
        }
        return "Unknown"
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
    
    func deselectAllChatPartner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.selectedChatPartners.removeAll()
        }
    }
    
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            guard let index = selectedChatPartners.firstIndex(where: {$0.id == item.id}) else {return}
            selectedChatPartners.remove(at: index)
        } else {
            guard selectedChatPartners.count < ChannelConstants.maxGroupParticipants else {
                let errorMessage = "Sorry We only allow a maximum of \(ChannelConstants.maxGroupParticipants) members in a group chat"
                showError(errorMessage)
                return
            }
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains {$0.id == user.id}
        return isSelected
    }
    
    func createDirectChannel(_ chatPartner: UserItem, completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        if selectedChatPartners.isEmpty {
            selectedChatPartners.append(chatPartner)
        }
        Task {
            if let channelID = await verifyDirectChannelExist(with: chatPartner.id) {
                let snapshot = try await FirebaseConstants.ChannelsRef.child(channelID).getData()
                let channelDict = snapshot.value as! [String: Any]
                var directChannel = ChannelItem(dict: channelDict)
                directChannel.members = selectedChatPartners
                if let currentUser {
                    directChannel.members.append(currentUser)
                }
                completion(directChannel)
            } else {
                let channelCreation = createChannel(nil)
                switch channelCreation {
                    
                case .success(let channel):
                    completion(channel)
                case .failure(let error):
                    showError("Sorry! Something Went Wrong While We Were Trying to Setup Your Group Chat")
                    print("failed to create group channel \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createGroupChannel(_ groupName: String? , completion: @escaping (_ newChannel: ChannelItem) -> Void) {
        let channelCreation = createChannel(groupName)
        switch channelCreation {
        case .success(let channel):
            completion(channel)
        case .failure(let error):
            showError("Sorry! Something Went Wrong While We Were Trying to Setup Your Group Chat")
            print("failed to create group channel \(error.localizedDescription)")
        }
    }
    
    private func verifyDirectChannelExist(with chatPartnerID: String) async -> String? {
        guard let currentId = Auth.auth().currentUser?.uid,
              let snapshot = try? await FirebaseConstants.UserDirectChannels.child(currentId).child(chatPartnerID).getData(),
              snapshot.exists()
        else {return nil}
        
        let directMessage = snapshot.value as! [String: Bool]
        let channelID = directMessage.compactMap {$0.key}.first
        return channelID
    }
    
    // MARK: Creating Channel
    private func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        
        guard !selectedChatPartners.isEmpty else {return .failure(ChannelCreationError.noParticipant)}
        
        guard
            let channelID = FirebaseConstants.ChannelsRef.childByAutoId().key,
            let currentId = Auth.auth().currentUser?.uid,
            let messageID = FirebaseConstants.MessageRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueID) }
        
        let timeStamp = Date().timeIntervalSince1970
        var memberUids = selectedChatPartners.compactMap {$0.id}
        memberUids.append(currentId)
        let newChannelBroadCast = AdminMessageType.channelCreation.rawValue
        
        var channelDict: [String: Any] = [
            .id: channelID,
            .lastMessage: newChannelBroadCast,
            .lastMessageType: newChannelBroadCast,
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .membersUids: memberUids,
            .membersCount: memberUids.count,
            .adminUids: [currentId],
            .createdBy: currentId
        ]
        
        if let name = channelName {
            channelDict[.name] = name
        }
        
        let messageDict: [String: Any] = [.text: newChannelBroadCast, .type: newChannelBroadCast, .timeStamp: timeStamp, .ownerId: currentId]
        
        FirebaseConstants.ChannelsRef.child(channelID).setValue(channelDict)
        FirebaseConstants.MessageRef.child(channelID).child(messageID).setValue(messageDict)
        memberUids.forEach { userId in
            ///Keeping an index of the channel that a specific user belong to
            FirebaseConstants.UserChannelRef.child(userId).child(channelID).setValue(true)
        }
        
        ///Makes sure that a direct channel is unique
        if isDirectchannel {
            let chatPartnerId = selectedChatPartners[0].id
            FirebaseConstants.UserDirectChannels.child(currentId).child(chatPartnerId).setValue([channelID: true])
            FirebaseConstants.UserDirectChannels.child(chatPartnerId).child(currentId).setValue([channelID: true])
        }
        
        var newChannelItem = ChannelItem(dict: channelDict)
        newChannelItem.members = selectedChatPartners
        if let currentUser {
            newChannelItem.members.append(currentUser)
        }
        return .success(newChannelItem)
    }
}
