//
//  StringExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 25/7/24.
//

import Foundation

extension String {
    static let id = "id"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
    static let name = "name"
    static let lastMessage = "lastMesssage"
    static let creationDate = "creationDate"
    static let lastMessageTimeStamp = "lastMessageTimeStamp"
    static let membersCount = "membersCount"
    static let adminUids = "adminUids"
    static let membersUids = "membersUids"
    static let thumbnailUrl = "thumbnailUrl"
    static let members = "members"
    static let createdBy = "createdBy"
    static let timeStamp = "timeStamp"
    static let ownerId = "ownerId"
    static let messageType = "messageType"
    static let text = "text"
    static let type = "type"
    var isEmptyOrWhiteSpaces: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
