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
            //            print("Channel: \(snapshot.value)")
            guard let dict = snapshot.value as? [String: Any] else { return }
            var channel = ChannelItem(dict: dict)
            self?.channels.append(channel)
            
            //            self?.getChannelMembers(channel) { members in
            //                channel.members = members
            //            }
        }
        FirebaseConstants.ChannelsRef.child(channelID).child("membersUids").observe(.value) { snapshot  in
            //            print(snapshot.value)
            guard let uids = snapshot.value as? [String] else {return}
            var users: [UserItem] = []
            for uid in uids {
                FirebaseConstants.UserRef.child(uid).observeSingleEvent(of: .value) { snapshot  in
                    //                    print(snapshot.value)
                    guard let user = snapshot.value as? [UserItem] else { return }
                    print(user)
                    guard let safeUser = user as? [UserItem] else {return}
                    print(user)
//                    users.append(user)
                    if users.count == uids.count {
                        print("Users are equal")
                    }
                }
            }
            
        }
    withCancel: { error in
        print("Failed to get the channel for id: \(channelID)")
    }
        
    }
    
    private func getChannelMembers(_ channel: ChannelItem, completion: @escaping (_ members: [UserItem]) -> Void) {
        UserService.getUsers(with: channel.membersUids) { userNode in
            completion(userNode.users)
        }
    }
}
