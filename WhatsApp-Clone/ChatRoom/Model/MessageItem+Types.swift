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
