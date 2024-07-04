//
//  MessageBubbleITem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.

import SwiftUI

struct MessageBubbleItem: Identifiable {
    
    let id = UUID().uuidString
    let text: String
    let type: MessageType
    let direction: MessageDirection
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var bgColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let sentPlaceholder = MessageBubbleItem(text: "Hoo Lee Sheet", type: .text, direction: .sent)
    static let receivedPlaceholder = MessageBubbleItem(text: "pette", type: .text, direction: .received)
    static let stubMessages: [MessageBubbleItem] = [
        MessageBubbleItem(text: "hello there", type: .text, direction: .received),
        MessageBubbleItem(text: "Check this photo", type: .photo, direction: .sent),
        MessageBubbleItem(text: "Play this video", type: .video, direction: .received)
    ]
}

enum MessageType {
    case text, photo, video
}
enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
