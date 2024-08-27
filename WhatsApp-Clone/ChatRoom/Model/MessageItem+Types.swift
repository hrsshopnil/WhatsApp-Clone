//
//  MessageItem+Types.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 27/7/24.
//

import Foundation

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
