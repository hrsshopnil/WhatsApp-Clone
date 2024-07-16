//
//  ChannelItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 16/7/24.
//

import Foundation

struct ChannelItem: Identifiable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: UInt
    var adminsUids: [String]
    var membersUids: [String]
    var members: [UserItem]
    var thumbnailUrl: String?
    
    var isGroupChat: Bool {
        return members.count > 2
    }
    
    static let placeholder = ChannelItem.init(id: "1", lastMessage: "hemlo", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminsUids: [], membersUids: [], members: [])
}
