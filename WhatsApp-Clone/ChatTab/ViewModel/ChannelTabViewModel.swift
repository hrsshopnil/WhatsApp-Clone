//
//  ChannelTabViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 17/7/24.
//

import Foundation
import Firebase

final class ChannelTabViewModel: ObservableObject {
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    @Published var channels = [ChannelItem]()
    
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
            guard let dict = snapshot.value as? [String: Bool] else { return }
            dict.forEach { key, value in
                let channelID = key
                self?.getChannel(with: channelID)
            }
        } withCancel: { error in
            print("Failed to get current users channel id \(error.localizedDescription)")
        }
    }
    
    private func getChannel(with channelID: String) {
        FirebaseConstants.ChannelsRef.child(channelID).observe(.value) {[weak self] snapshot  in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var channel = ChannelItem(dict: dict)
            self?.getChannelMembers(channel) { members in
                channel.members = members
                self?.channels.append(channel)
            }
            print(channel.title)
        } withCancel: { error in
            print("Failed to get the channel for id: \(channelID)")
        }
    }
    
    private func getChannelMembers(_ channel: ChannelItem, completion: @escaping (_ members: [UserItem]) -> Void) {
        UserService.getUsers(with: channel.membersUids) { userNode in
            completion(userNode.users)
        }
    }
}
