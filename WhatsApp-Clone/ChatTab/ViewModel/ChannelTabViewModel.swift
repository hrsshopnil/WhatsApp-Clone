//
//  ChannelTabViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 17/7/24.
//

import Foundation
import Firebase

enum ChannelTabRouts: Hashable {
    case chatRoom(_ channel: ChannelItem)
}

final class ChannelTabViewModel: ObservableObject {
    
    @Published var navRouts = [ChannelTabRouts]()
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    @Published var channels = [ChannelItem]()
    @Published var channelDictionary: [String: ChannelItem] = [:]
    
    init() {
        fetchCurrentUserChannel()
    }
    
    func onNewChannelCreation(_ channel: ChannelItem) {
        navigateToChatRoom = true
        newChannel = channel
        showChatPartnerPickerView = false
    }
    
    private func fetchCurrentUserChannel() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.UserChannelRef.child(currentUid).observe(.value) {[weak self] snapshot in
            guard let dict = snapshot.value as? [String: Int] else { return }
            dict.forEach { key, value in
                print(key)
                let channelID = key
                let unreadCount = value
                self?.getChannel(with: channelID, unreadCount: unreadCount)
                print("unreadCount: \(unreadCount)")
            }
            
        } withCancel: { error in
            print("Failed to get current users channel id \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelID: String, unreadCount: Int) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        print(currentUser)
        FirebaseConstants.ChannelsRef.child(channelID).observe(.value) { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var channel = ChannelItem(dict: dict)
            
            self?.getChannelMembers(with: channel) { members in
                channel.members = members
          //      channel.members.append(currentUser)
                channel.unreadCount = unreadCount
                self?.channelDictionary[channelID] = channel
                self?.reloadData()
            }
        }
    }


    
    private func getChannelMembers(with channel: ChannelItem, completion: @escaping ([UserItem]) -> Void) {
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }
        //let memberUids = Array(channel.membersUids.filter { $0 != currentUid }.prefix(2))
        UserService.getUsers(with: channel.membersUids) { userNode in
            completion(userNode.users)
        }
    }
    private func reloadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort {$0.lastMessageTimeStamp > $1.lastMessageTimeStamp}
    }
}
