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
    
    static func getUsers(with uids: [String], completion: @escaping (UserNode) -> Void) {
        var users: [UserItem] = []
        for uid in uids {
            let query = FirebaseConstants.UserRef.child(uid)
            print(uid)
            query.observeSingleEvent(of: .value) { snapshot in
                print("snapshot found")
                guard let user = try? snapshot.data(as: UserItem.self) else { return }
                users.append(user)
                if users.count == uids.count {
                    print("Users are equal")
                    completion(UserNode(users: users))
                }
            } withCancel: { error in
                print(error)
                completion(.emptyNode)
            }
        }
    }
    
    static func paginateUsers(lastCursor: String? , pageSize: UInt) async throws -> UserNode {
        let mainSnapshot: DataSnapshot
        if lastCursor == nil {
            // Initial Data fetch
            mainSnapshot = try await FirebaseConstants.UserRef.queryLimited(toLast: pageSize).getData()
        } else {
            //Fetching data for the 2nd time and so On
            mainSnapshot = try await FirebaseConstants.UserRef
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
