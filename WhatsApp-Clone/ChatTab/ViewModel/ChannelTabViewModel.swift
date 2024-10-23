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
                self?.getChannel(with: channelID)
                print("unreadCount: \(unreadCount)")
            }
            
        } withCancel: { error in
            print("Failed to get current users channel id \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelID: String) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.ChannelsRef.child(channelID).observe(.value) { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var channel = ChannelItem(dict: dict)
            
            if let memberUid = channel.membersUids.first(where: { $0 != currentUid }) {
                // Fetch the member's name asynchronously
                self?.getChannelMembersName(with: memberUid) { name in
                    channel.name = name // Update the channel's name
                    
                    // Once the name is updated, update the dictionary and reload the data
                    self?.channelDictionary[channelID] = channel
                    self?.reloadData()
                    
                    print("name: \(name)") // For debugging purposes
                }
            } else {
                // If no other member is found, update the dictionary immediately
                self?.channelDictionary[channelID] = channel
                self?.reloadData()
            }
        }
    }


    
    private func getChannelMembersName(with memberUid: String, completion: @escaping (String) -> Void) {
        FirebaseConstants.UserRef.child(memberUid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let member = UserItem(dictionary: dict)
            completion(member.username)
        }
    }
    private func reloadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort {$0.lastMessageTimeStamp > $1.lastMessageTimeStamp}
    }
}
