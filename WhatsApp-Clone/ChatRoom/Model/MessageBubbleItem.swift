//
//  MessageBubbleITem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.
//

import Foundation

struct MessageBubbleItem: Identifiable {
    
    let id = UUID().uuidString
    let text: String
    let direction: MessageDirection
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
