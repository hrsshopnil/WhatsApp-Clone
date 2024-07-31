//
//  MessageBubbleITem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.

import SwiftUI
import Firebase

struct MessageItem: Identifiable {
    
    let id: String
    let text: String
    let type: MessageType
    let ownerId: String
    
    var direction: MessageDirection {
        return ownerId == Auth.auth().currentUser?.uid ? .sent : .received
    }
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var bgColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "1")
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "2")
    
    static let stubMessages: [MessageItem] = [
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "3"),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .photo, ownerId: "4"),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .video, ownerId: "5"),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .audio, ownerId: "6")
    ]
}

extension MessageItem {
    init(id: String, dict: [String: Any]) {
        self.id = id
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type)
        self.ownerId = dict[.ownerID] as? String ?? ""
    }
}
enum MessageType {
    case text, photo, video, audio
    
    var title: String {
        switch self {
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
    
    init(_ stringValue: String) {
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
            self = .text
        }
    }
}

enum MessageDirection {
    case sent, received
    
    //    static var random: MessageDirection {
    //        return [MessageDirection.sent, .received].randomElement() ?? .sent
    //    }
}
