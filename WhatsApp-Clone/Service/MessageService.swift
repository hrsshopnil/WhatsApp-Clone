//
//  MessageService.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/7/24.
//

import Foundation
import Firebase
class MessageService {
    static func sendTextMessage(to channel: ChannelItem, from  currentUser: UserItem, _ textMessage: String, completion: () -> Void) {
        let timeStamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.MessageRef.childByAutoId().key else {return}
        let channelDict: [String: Any] = [
            .lastMessage: textMessage,
            .lastMessageTimeStamp: timeStamp
        ]
        
        let messageDict: [String: Any] = [
            .text: textMessage,
            .type: MessageType.text.title,
            .timeStamp: timeStamp,
            .ownerId: currentUser.id
        ]
        FirebaseConstants.ChannelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessageRef.child(channel.id).child(messageId).setValue(messageDict)
        completion()
    }
}
