//
//  MessageService.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/7/24.
//

import Foundation
import Firebase
import FirebaseDatabase

class MessageService {
    
    /// Sends a text message to the Realtime Database
    static func sendTextMessage(to channel: ChannelItem, from  currentUser: UserItem, _ textMessage: String, completion: () -> Void) {
        let timeStamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.MessageRef.childByAutoId().key else { return }
        let channelDict: [String: Any] = [
            .lastMessage: textMessage,
            .lastMessageTimeStamp: timeStamp,
            .lastMessageType: MessageType.text.title
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
    
    ///Gets Messages for the selected channel
//    static func getMessages(_ channel: ChannelItem, completion: @escaping ([MessageItem]) -> Void) {
//        FirebaseConstants.MessageRef.child(channel.id).observe(.value) { snapshot in
//            guard let dict = snapshot.value as? [String: Any] else { return }
//            var messages: [MessageItem] = []
//            dict.forEach { key, value in
//                
//                let messageDict = value as? [String: Any] ?? [:]
//                var message = MessageItem(id: key, isGroupChat: channel.isGroupChat, dict: messageDict)
//                let messageSender = channel.members.first(where: { $0.id == message.ownerId })
//                
//                message.sender = messageSender
//                messages.append(message)
//                
//                if messages.count == snapshot.childrenCount {
//                    messages.sort { $0.timeStamp < $1.timeStamp }
//                    completion(messages)
//                }
//            }
//        } withCancel: { error in
//            print("Failed to get message for \(channel.id)")
//        }
//    }
    
    
    ///Sends messages that include Photo, Video or audio
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
        
        ///Photo or Video Messages
        messageDict[.thumbnailUrl] = params.thumbnailUrl ?? nil
        messageDict[.thumbnailWidth] = params.thumbnailWidth ?? nil
        messageDict[.thumbnailHeight] = params.thumbnailHeight ?? nil
        messageDict[.videoUrl] = params.videoUrl ?? nil
        
        /// Audio Messages
        messageDict[.audioUrl] = params.audioUrl ?? nil
        messageDict[.audioDuration] = params.audioDuration ?? nil
        
        FirebaseConstants.ChannelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.MessageRef.child(channel.id).child(messageId).setValue(messageDict)
        completion()
    }
    
    ///Paginating Messages for a Channel
    static func getHistoricalMessages(for channel: ChannelItem, lastCursor: String?, pageSize: UInt, completion: @escaping (MessageNode) -> Void) {
        
        let query: DatabaseQuery
        
        if lastCursor == nil {
            query = FirebaseConstants.MessageRef.child(channel.id).queryLimited(toLast: pageSize)
        } else {
            query = FirebaseConstants.MessageRef.child(channel.id)
                .queryOrderedByKey()
                .queryEnding(atValue: lastCursor)
                .queryLimited(toLast: pageSize)
        }
        
        query.observeSingleEvent(of: .value) { mainSnapshot in
            guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
                  let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            var messages: [MessageItem] = allObjects.compactMap { messageSnapshot in
                
                let messageDict = messageSnapshot.value as? [String: Any] ?? [:]
                var message = MessageItem(id: messageSnapshot.key, isGroupChat: channel.isGroupChat, dict: messageDict)
                let messageSender = channel.members.first(where: { $0.id == message.ownerId })
                
                message.sender = messageSender
                return message
            }
            
            messages.sort { $0.timeStamp < $1.timeStamp }
            if messages.count == mainSnapshot.childrenCount {
                
                let filteredMessages = lastCursor == nil ? messages : messages.filter { $0.id != lastCursor }
                let messageNode = MessageNode(messages: filteredMessages, currentCursor: first.key)
                
                completion(messageNode)
            }
            
        } withCancel: { error in
            print("Failed to paginate Messages \(error)")
        }
    }
    
    static func getFirstMessages(for channel: ChannelItem, completion: @escaping (MessageItem) -> Void) {
        FirebaseConstants.MessageRef.child(channel.id).queryLimited(toFirst: 1).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach { key, value in
                guard let messageDict = snapshot.value as? [String: Any] else { return }
                var firstMessage = MessageItem(id: key, isGroupChat: channel.isGroupChat, dict: messageDict)
                let messageSender = channel.members.first(where: { $0.id == firstMessage.ownerId })
                firstMessage.sender = messageSender
                completion(firstMessage)
            }
        }
    }
    
    static func listenForNewMessages(for channel: ChannelItem, completion: @escaping (MessageItem) -> Void) {
        FirebaseConstants.MessageRef.child(channel.id).observe(.childAdded) { snapshot in
            guard let messageDict = snapshot.value as? [String: Any] else { return }
            var newMessage = MessageItem(id: snapshot.key, isGroupChat: channel.isGroupChat, dict: messageDict)
            let messageSender = channel.members.first(where: { $0.id == newMessage.ownerId })
            newMessage.sender = messageSender
            completion(newMessage)
        }
    }

}

struct MessageNode {
    var messages: [MessageItem]
    var currentCursor: String?
    static let emptyNode = MessageNode(messages: [], currentCursor: nil)
}

///Media Message Item Model
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
