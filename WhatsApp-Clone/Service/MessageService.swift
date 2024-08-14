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
    
    static func getMessages(_ channel: ChannelItem, completion: @escaping ([MessageItem]) -> Void) {
        FirebaseConstants.MessageRef.child(channel.id).observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var messages: [MessageItem] = []
            dict.forEach { key, value in
                let messageDict = value as? [String: Any] ?? [:]
                let message = MessageItem(id: key,isGroupChat: channel.isGroupChat, dict: messageDict)
                messages.append(message)
                if messages.count == snapshot.childrenCount {
                    messages.sort { $0.timeStamp < $1.timeStamp }
                    completion(messages)
                }
            }
        } withCancel: { error in
            print("Failed to get message for \(channel.id)")
        }
    }
    
    static func sendMediaMessage(to channel: ChannelItem, params: MessageUploadParams, completion: @escaping () -> Void) {
        guard let messageId = FirebaseConstants.MessageRef.childByAutoId().key else { return }
        let timeStamp = Date().timeIntervalSince1970

        let channelDict: [String: Any] = [
            .lastMessage: params.text,
            .lastMessageTimeStamp: timeStamp,
            .lastMessageType: params.type.title
        ]

        var messageDict: [String: Any] = [
            .text: params.text,
            .type: params.type.title,
            .timeStamp: timeStamp,
            .ownerId: params.ownerId,
        ]
        
        messageDict[.thumbnailUrl] = params.thumbnailUrl ?? nil
        messageDict[.thumbnailUrl] = params.thumbnailUrl ?? nil
        messageDict[.thumbnailUrl] = params.thumbnailUrl ?? nil
        
        FirebaseConstants.ChannelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessageRef.child(channel.id).child(messageId).setValue(messageId)
        completion()
    }

}

struct MessageUploadParams {
    let channel: ChannelItem
    let text: String
    let type: MessageType
    let attachment: MediaAttachment
    var thumbnailUrl: String?
    var videoUrl: String?
    var sender: UserItem
    var audioUrl: String?
    var audioDuration: TimeInterval?
    
    var ownerId: String {
        return sender.id
    }
    
    var thumbnailWidth: CGFloat? {
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbnail.size.width
    }
    
    var thumbnailHeight: CGFloat? {
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbnail.size.height
    }
}
