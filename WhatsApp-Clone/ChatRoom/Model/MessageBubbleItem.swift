//
//  MessageBubbleITem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.

import SwiftUI

struct MessageBubbleItem: Identifiable {
    
    let id = UUID().uuidString
    let text: String
    let direction: MessageDirection
    
    static let sentPlaceholder = MessageBubbleItem(text: "Hoo Lee Sheet", direction: .sent)
    static let receivedPlaceholder = MessageBubbleItem(text: "pette", direction: .received)
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var bgColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
