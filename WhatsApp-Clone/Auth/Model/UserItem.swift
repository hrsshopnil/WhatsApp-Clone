//
//  UserItem.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation

struct UserItem: Identifiable, Hashable, Codable {
    let id: String
    let username: String
    let email: String
    var bio: String? = "Hey there I'm using whatsapp"
    var profileImageUrl: String? = nil
    
    static let placeHolder = UserItem(id: "2", username: "hrrshopnil", email: "a@b")
}

extension String {
    static let id = "id"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}

extension UserItem {
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? nil
    }
}
