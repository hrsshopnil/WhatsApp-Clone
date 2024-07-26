//
//  ChannelItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 16/7/24.
//

import Foundation
import Firebase

struct ChannelItem: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: UInt
    var adminUids: [String]
    var membersUids: [String]
    var members: [UserItem]
    var thumbnailUrl: String?
    var createdBy: String
    
    var isGroupChat: Bool {
        return members.count > 2
    }
    
    var memberExcludingMe: [UserItem] {
        guard let currentId = Auth.auth().currentUser?.uid else { return [] }
        return members.filter {$0.id != currentId}
    }
    
    var title: String {
        if let name = name {
            return name
        }
        
        if isGroupChat {
            return "Group Chat"
        } else {
            return memberExcludingMe.first?.username ?? "Unknown"
        }
    }
    static let placeholder = ChannelItem.init(id: "1", lastMessage: "hemlo", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], membersUids: [], members: [], createdBy: "")
}
