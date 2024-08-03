//
//  ChannelItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 16/7/24.
//

import Foundation
import Firebase

struct ChannelItem: Identifiable, Hashable {
    var id: String
    var name: String?
    var lastMessage: String
    var creationDate: Date
    var lastMessageTimeStamp: Date
    var membersCount: Int
    var adminUids: [String]
    var membersUids: [String]
    var members: [UserItem]
    private var thumbnailUrl: String?
    var createdBy: String
    
    // MARK: gives a name that is computed in local machine
    var isGroupChat: Bool {
        return membersUids.count > 2
    }
    
    var title: String {
        if let channelName = name {
            let maxChar = 20
            let trailingChars = channelName.count > maxChar ? " ..." : ""
            let title = String(channelName.prefix(maxChar) + trailingChars)
            return title
        } else {
            return "Unknown"
        }
    }
    var allmemberFetched: Bool {
        return members.count == membersCount
    }
    var isCreatedByMe: Bool {
        return createdBy == K.currentUserId
    }
    
    var creatorName: String {
        return members.first {$0.id == createdBy}?.username ?? "Someone"
    }
    
    var coverImageUrl: String? {
        if let thumbnailUrl {
            return thumbnailUrl
        }
        
        if !isGroupChat {
            return membersExcludingMe.first?.profileImageUrl
        }
        
        return nil
    }
    
    private var membersExcludingMe: [UserItem] {
        guard let currentId = K.currentUserId else { return [] }
        return members.filter {$0.id != currentId}
    }
//
//    private var membersExcludingMe: [UserItem] {
//        guard let currentId = Auth.auth().currentUser?.uid else { return [] }
//        return members.filter {$0.id != currentId}
//    }
//    
//    var title: String {
//        if let name = name {
//            return name
//        }
//        
//        if isGroupChat {
//            return groupMemberNames
//        } else {
//            return membersExcludingMe.first?.username ?? "Unknown"
//        }
//    }
//    
//    private var groupMemberNames: String {
//        let membmersCount = membersExcludingMe.count
//        let fullNames: [String] = membersExcludingMe.map { $0.username }
//        
//        if membmersCount == 2 {
//            return fullNames.joined(separator: " and ")
//        } else if membmersCount > 2 {
//            let remainingCount = membmersCount - 2
//            return fullNames.prefix(2).joined(separator: ", ") + ", and \(remainingCount) others"
//        }   
//        return "Unknown"
//    }
    
    static let placeholder = ChannelItem.init(id: "1", lastMessage: "hemlo", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], membersUids: [], members: [], createdBy: "")
}

extension ChannelItem {
    init(dict: [String: Any]) {
        self.id = dict[.id] as? String ?? ""
        self.name = dict[.name] as? String? ?? nil
        self.lastMessage = dict[.lastMessage] as? String ?? ""

        let creationInterval = dict[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)

        let lastMsgTimeStampInterval = dict[.lastMessageTimeStamp] as? Double ?? 0
        self.lastMessageTimeStamp = Date(timeIntervalSince1970: lastMsgTimeStampInterval)

        self.membersCount = dict[.membersCount] as? Int ?? 0
        self.adminUids = dict[.adminUids] as? [String] ?? []
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
        self.membersUids = dict[.membersUids] as? [String] ?? []
        self.members = dict[.members] as? [UserItem] ?? []
        self.createdBy = dict[.createdBy] as? String ?? ""
    }
}
