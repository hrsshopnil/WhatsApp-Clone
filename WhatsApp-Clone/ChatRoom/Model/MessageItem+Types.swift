//
//  MessageItem+Types.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 27/7/24.
//

import Foundation

enum MessagesMenuAction: String, CaseIterable, Identifiable {
    case reply, forward, copy, delete
    
    var id: String {
        return rawValue
    }
    
    var systemImage: String {
        switch self {
        case .reply:
            return "arrowshape.turn.up.left"
        case .forward:
            return "paperplane"
        case .copy:
            return "doc.on.doc"
        case .delete:
            return "trash"
        }
    }
}

enum Reaction: Int {
    case like, love, laugh, shocked, sad, pray, more
    
    var emoji: String {
        switch self {
        case .like:
            return "👍"
        case .love:
            return "❤️"
        case .laugh:
            return "😂"
        case .shocked:
            return "😯"
        case .sad:
            return "😭"
        case .pray:
            return "🙏"
        case .more:
            return "+"
        }
    }
}

enum AdminMessageType: String {
    case channelCreation, memberAdd, memberLeft, channelNameChanged
}

/// Cases: admin, text, photo, video, audio
enum MessageType: Hashable {
    case admin(_ type: AdminMessageType), text, photo, video, audio
    
    var isAdminMessage: Bool {
        if case .admin = self {
            return true
        } else {
            return false
        }
    }
    
    var title: String {
        switch self {
        case .admin:
            return "admin"
        case .text:
            return "text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .audio:
            return "audio"
        }
    }
    
    init?(_ stringValue: String) {
        switch stringValue {
        case "text":
            self = .text
        case "photo":
            self = .photo
        case "video":
            self = .video
        case "audio":
            self = .audio
        default:
            if let adminMessageType = AdminMessageType(rawValue: stringValue) {
                self = .admin(adminMessageType)
            } else {
                return nil
            }
        }
    }
}
