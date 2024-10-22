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
        increaseUnreadCountForMembers(in: channel)
        completion()
    }
    
    
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
        increaseUnreadCountForMembers(in: channel)
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
                if lastCursor == nil { messages.removeLast() }
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
        FirebaseConstants.MessageRef.child(channel.id).queryLimited(toLast: 1).observe(.childAdded) { snapshot in
            
            guard let messageDict = snapshot.value as? [String: Any] else { return }
            
            var newMessage = MessageItem(id: snapshot.key, isGroupChat: channel.isGroupChat, dict: messageDict)
            let messageSender = channel.members.first(where: { $0.id == newMessage.ownerId })
            
            newMessage.sender = messageSender
            completion(newMessage)
        }
    }
    
    static func increaseCountViaTransaction(at ref: DatabaseReference, completion: ((Int) -> Void)? = nil) {
        ref.runTransactionBlock { currentData in
            if var count = currentData.value as? Int{
                count += 1
                currentData.value = count
            } else {
                currentData.value = 1
            }
            completion?(currentData.value as? Int ?? 0)
            return TransactionResult.success(withValue: currentData)
        }
    }

    static func addReaction(_ reaction: Reaction, to message: MessageItem, in channel: ChannelItem, from currentUser: UserItem, completion: @escaping(_ emojiCount: Int) -> Void) {
        // Increase emoji reaction count
        let reactionRef = FirebaseConstants.MessageRef.child(channel.id).child(message.id).child(.reactions).child(reaction.emoji)
        
        increaseCountViaTransaction(at: reactionRef) { emojiCount in
            FirebaseConstants.MessageRef.child(channel.id).child(message.id).child(.userReactions).child(currentUser.id).setValue(reaction.emoji)
            
            completion(emojiCount)
        }
    }
    
    static func increaseUnreadCountForMembers(in channel: ChannelItem) {
        let memberUids = channel.membersExcludingMe.map { $0.id }
        for uid in memberUids {
            let channelUnreadCountRef = FirebaseConstants.UserChannelRef.child(uid).child(channel.id)
            increaseCountViaTransaction(at: channelUnreadCountRef)
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
