//
//  UserService.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 15/7/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct UserService {
    
    static func paginateUsers(lastCursor: String? , pageSize: UInt) async throws -> UserNode {
        let mainSnapshot: DataSnapshot
        if lastCursor == nil {
            // Initial Data fetch
            mainSnapshot = try await FirebaseConstants.userRef.queryLimited(toLast: pageSize).getData()
        } else {
            mainSnapshot = try await FirebaseConstants.userRef
                .queryOrderedByKey()
                .queryEnding(atValue: lastCursor)
                .queryLimited(toLast: pageSize + 1)
                .getData()
        }
        guard let first = mainSnapshot.children.allObjects.first as? DataSnapshot,
              let allObjects = mainSnapshot.children.allObjects as? [DataSnapshot] else { return .emptyNode }
        
        let users: [UserItem] = allObjects.compactMap { userSnapshot in
            let userDict = userSnapshot.value as? [String: Any] ?? [:]
            return UserItem(dictionary: userDict)
        }
        
        if users.count == mainSnapshot.childrenCount {
            let filteredUser = lastCursor == nil ? users : users.filter {$0.id != lastCursor}
            let userNode = UserNode(users: filteredUser, currentCursor: first.key)
            return userNode
        }
        return .emptyNode
    }
    
    struct UserNode {
        var users: [UserItem]
        var currentCursor: String?
        static let emptyNode = UserNode(users: [], currentCursor: nil)
    }
}
