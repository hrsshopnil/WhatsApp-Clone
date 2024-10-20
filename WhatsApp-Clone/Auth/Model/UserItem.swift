//
//  UserItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation

struct UserItem: Identifiable, Hashable, Codable {
    let email: String
    let id: String
    var username: String
    var bio: String?
    var profileImageUrl: String? = nil
    
    var bioUnwrapped: String {
        return bio ?? "Hey there I'm using whatsapp"
    }
    static let placeHolder = UserItem(email: "a@b", id: "2", username: "hrrshopnil")
    
        static let placeHolders: [UserItem] = [UserItem(email: "ramesh@example.com", id: "1", username: "Ramesh", bio: "Hey there, I'm Ramesh!"),
                                               UserItem(email: "karim@example.com", id: "2", username: "Karim", bio: "Hi, I'm Karim! Nice to meet you."),
                                               UserItem(email: "sophie@example.com", id: "3", username: "Sophie", bio: "Hello, I'm Sophie. Let's chat!")]
}
extension UserItem {
    init(dictionary: [String: Any]) {
        self.email = dictionary[.email] as? String ?? ""
        self.id = dictionary[.id] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? nil
    }
}
