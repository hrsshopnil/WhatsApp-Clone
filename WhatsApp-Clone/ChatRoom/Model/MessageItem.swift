//
//  MessageBubbleITem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.

import SwiftUI
import Firebase

struct MessageItem: Identifiable {
    
    let id: String
    let isGroupChat: Bool
    let text: String
    let type: MessageType
    let ownerId: String
    let timeStamp: Date
    var sender: UserItem?
    let thumbnailUrl: String?
    
    var imageUrl: String {
        guard let thumbnailUrl else { return ""}
        return thumbnailUrl
    }
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
    var showSenderProfile: Bool {
        return isGroupChat && direction == .received
    }
    
    var leadingPadding: CGFloat {
        return direction == .received ? 0 : 25
    }
    
    var trailingPadding: CGFloat {
        return direction == .received ? 25 : 0
    }
    
    static let sentPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .text, ownerId: "1", timeStamp: Date(), thumbnailUrl: nil)
    static let receivedPlaceholder = MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .text, ownerId: "2", timeStamp: Date(), thumbnailUrl: nil)
    
    static let stubMessages: [MessageItem] = [
        MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .text, ownerId: "3", timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .photo, ownerId: "4", timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .video, ownerId: "5", timeStamp: Date(), thumbnailUrl: nil),
        MessageItem(id: UUID().uuidString, isGroupChat: true, text: "Hoo lee Sheet", type: .audio, ownerId: "6", timeStamp: Date(), thumbnailUrl: nil)
    ]
}

extension MessageItem {
    init(id: String, isGroupChat: Bool, dict: [String: Any]) {
        self.id = id
        self.isGroupChat = isGroupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? "text"
        self.type = MessageType(type) ?? .text
        self.ownerId = dict[.ownerId] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
        self.thumbnailUrl = dict[.thumbnailUrl] as? String ?? nil
    }
}
/// Cases: admin, text, photo, video, audio
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
    
    static func == (lhs: MessageType, rhs: MessageType) -> Bool {
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
