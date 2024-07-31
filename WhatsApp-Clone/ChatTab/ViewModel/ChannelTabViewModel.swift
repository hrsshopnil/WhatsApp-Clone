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
            //            print("Channel: \(snapshot.value)")
            guard let dict = snapshot.value as? [String: Any] else { return }
            let channel = ChannelItem(dict: dict)
//            getMemberUids(channelID: channelID) { names in
//                var channel = ChannelItem(dict: dict)
//                channel.name = names
//            }
            self?.channelDictionary[channelID] = channel
            self?.reloadData()
            
            //            self?.getChannelMembers(channel) { members in
            //                channel.members = members
            //            }
        }
    }
//    private func getMemberUids(channelID: String, completion: @escaping (_ names: String) -> Void) {
//        FirebaseConstants.ChannelsRef.child(channelID).child("membersUids").observe(.value) {[weak self] snapshot  in
//            //            print(snapshot.value)
//            guard let uids = snapshot.value as? [String] else {return}
//            self?.getMemberNames(uids: uids) { names in
//                completion(names)
//            }
//        }
//    }
//    private func getMemberNames(uids: [String], completion: @escaping (_ names: String) -> Void) {
//        for uid in uids {
//            FirebaseConstants.UserRef.child(uid).child("username").observeSingleEvent(of: .value) { snapshot   in
////                    print(snapshot.value)
//                guard let user = snapshot.value as? String else { return }
//                completion(user)
//            }
//        }
//    }

            
//        }
//    }
//    
//    private func getChannelMembers(_ channel: ChannelItem, completion: @escaping (_ members: [UserItem]) -> Void) {
//        UserService.getUsers(with: channel.membersUids) { userNode in
//            completion(userNode.users)
//        }
//    }
    
    private func reloadData() {
        self.channels = Array(channelDictionary.values)
        self.channels.sort {$0.lastMessageTimeStamp > $1.lastMessageTimeStamp}
    }
}
