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
    let username: String
    var bio: String?
    var profileImageUrl: String? = nil
    
    var bioUnwrapped: String {
        return bio ?? "Hey there I'm using whatsapp"
    }
    static let placeHolder = UserItem(email: "a@b", id: "2", username: "hrrshopnil")
    
        static let placeHolders: [UserItem] = [UserItem(email: "ramesh@example.com", id: "1", username: "Ramesh", bio: "Hey there, I'm Ramesh!"),
                                               UserItem(email: "karim@example.com", id: "2", username: "Karim", bio: "Hi, I'm Karim! Nice to meet you."),
                                               UserItem(email: "sophie@example.com", id: "3", username: "Sophie", bio: "Hello, I'm Sophie. Let's chat!")]
    //                                           UserItem(id: "4", username: "Maxwell", email: "maxwell@example.com", bio: "Hey, Maxwell here. How are you?"),
    //                                           UserItem(id: "5", username: "Lily", email: "lily@example.com", bio: "Hi, I'm Lily. Excited to connect!"),
    //                                           UserItem(id: "6", username: "Oliver", email: "oliver@example.com", bio: "Hello, Oliver speaking. What's up?"),
    //                                           UserItem(id: "7", username: "Emma", email: "emma@example.com", bio: "Hey, I'm Emma. Nice to e-meet you!"),
    //                                           UserItem(id: "8", username: "Sebastian", email: "sebastian@example.com", bio: "Hi there, Sebastian here. Ready for a chat!"),
    //                                           UserItem(id: "9", username: "Isabella", email: "isabella@example.com", bio: "Hello, I'm Isabella. Let's connect!"),
    //                                           UserItem(id: "10", username: "Gabriel", email: "gabriel@example.com", bio: "Hey, Gabriel here. Excited to chat!"),
    //                                           UserItem(id: "11", username: "Ava", email: "ava@example.com", bio: "Hi, I'm Ava. Nice to meet you."),
    //                                           UserItem(id: "12", username: "Leo", email: "leo@example.com", bio: "Hello, Leo here. Let's have a conversation!"),
    //                                           UserItem(id: "13", username: "Ella", email: "ella@example.com", bio: "Hey, I'm Ella. How's it going?"),
    //                                           UserItem(id: "14", username: "Lucas", email: "lucas@example.com", bio: "Hi, Lucas here. Ready to connect!"),
    //                                           UserItem(id: "15", username: "Amelia", email: "amelia@example.com", bio: "Hello, I'm Amelia. Let's chat!"),
    //                                           UserItem(id: "16", username: "William", email: "william@example.com", bio: "Hey, William here. Nice to meet you!"),
    //                                           UserItem(id: "17", username: "Mia", email: "mia@example.com", bio: "Hi, I'm Mia. Ready to chat!"),
    //                                           UserItem(id: "18", username: "Henry", email: "henry@example.com", bio: "Hello, Henry here. How can I help you?"),
    //                                           UserItem(id: "19", username: "Charlotte", email: "charlotte@example.com", bio: "Hey, I'm Charlotte. Let's connect!"),
    //                                           UserItem(id: "20", username: "James", email: "james@example.com", bio: "Hi, I'm James. Excited to chat!")]
}
extension UserItem {
    init(dictionary: [String: Any]) {
        self.id = dictionary[.id] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? nil
    }
}
