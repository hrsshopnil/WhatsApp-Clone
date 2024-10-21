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
        FirebaseConstants.ChannelsRef.child(channelID).observe(.value) {[weak self] snapshot   in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let channel = ChannelItem(dict: dict)
            self?.channelDictionary[channelID] = channel
            self?.reloadData()
        }
    }
    
    private func reloadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort {$0.lastMessageTimeStamp > $1.lastMessageTimeStamp}
    }
}
