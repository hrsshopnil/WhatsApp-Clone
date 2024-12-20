//
//  StringExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 25/7/24.
//

import Foundation
import SwiftUI
import PhotosUI
import AVFoundation
import UIKit

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
    static let lastMessageType = "lastMessageType"
    static let thumbnailWidth = "thumbnailWidth"
    static let thumbnailHeight = "thumbnailHeight"
    static let videoUrl = "videoUrl"
    static let audioUrl = "audioUrl"
    static let audioDuration = "audioDuration"
    static let reactions = "reactions"
    static let userReactions = "userReactions"
    static let unreadCount = "unreadCount"

    
    var isEmptyOrWhiteSpaces: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension PhotosPickerItem {
    var isVideo: Bool {
        let videoUTTypes: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}


extension Array where Element == String {
    func uidExcludingMe(currentId: String) -> [String] {
        return self.filter { $0 != currentId } ?? []
    }
}
