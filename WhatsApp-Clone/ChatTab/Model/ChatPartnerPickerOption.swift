//
//  ChatPartnerPickerOption.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 14/7/24.
//

import Foundation

enum ChatPartnerPickerOption: String, CaseIterable, Identifiable {
    case newGroup = "New Group"
    case newChat = "New Contact"
    case addToContact = "New Community"
    
    var id: String {
        return rawValue
    }
    
    var title: String {
        return rawValue
    }
    
    var imageName: String {
        switch self {
            
        case .newGroup:
            return "person.2.fill"
        case .newChat:
            return "person.fill.badge.plus"
        case .addToContact:
            return "person.3.fill"
        }
    }
}
