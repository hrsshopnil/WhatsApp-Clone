//
//  getcurrent.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 16/10/24.
//

import FirebaseDatabase
import FirebaseAuth

class GetCurrentUser: ObservableObject {
    
    @Published var user: UserItem = UserItem(email: "", id: "", username: "")
    
    init() {
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            print("failed to get currentuid")
            return
        }
        print("currentUid: \(currentUid)")
        FirebaseConstants.UserRef.child(currentUid).observeSingleEvent(of: .value) {[weak self] snapshot in
            print("snapshot: \(snapshot)")
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            print("dict: \(userDictionary)")
            let loggedInUser = UserItem(dictionary: userDictionary)
            print("user: \(loggedInUser)")
            self?.user = loggedInUser
            print("🔐\(loggedInUser.username) is logged in")
            
        } withCancel: { error in
            print("Failed to get current user info")
        }
    }
}
