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
    let timeStamp: Date
    
    var direction: MessageDirection {
        return ownerId == K.currentUserId ? .sent : .received
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
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "1", timeStamp: Date())
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "2", timeStamp: Date())
    
    static let stubMessages: [MessageItem] = [
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .text, ownerId: "3", timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .photo, ownerId: "4", timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .video, ownerId: "5", timeStamp: Date()),
        MessageItem(id: UUID().uuidString, text: "Hoo lee Sheet", type: .audio, ownerId: "6", timeStamp: Date())
    ]
}

extension MessageItem {
    init(id: String, dict: [String: Any]) {
        self.id = id
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerId = dict[.ownerId] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
    }
}
enum MessageType {
    case admin(_ type: AdminMessageType), text, photo, video, audio
    
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

extension MessageType: Equatable {
    static func ==(lhs: MessageType, rhs: MessageType) -> Bool {
        switch(lhs, rhs) {
        case (.admin(let leftAdmin), .admin(let rightAdmin)):
            return leftAdmin == rightAdmin
            
        case (.text, .text),
            (.photo, .photo),
            (.video, .video),
            (.audio, .audio):
            return true
            
        default:
            return false
        }
    }
}
enum MessageDirection {
    case sent, received
    
        static var random: MessageDirection {
            return [MessageDirection.sent, .received].randomElement() ?? .sent
        }
}
