//
//  AuthProvidor.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 9/7/24.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase

enum AuthState {
    case pending, loggedin(UserItem), loggedout
}

enum AuthError: Error {
    case failedToRegister(_ description: String), failedToSaveData(_ description: String)
    
    var errorMessage: String? {
        switch self {
            
        case .failedToRegister(let description):
            return description
        case .failedToSaveData(let description):
            return description
        }
    }
}

protocol AuthProvidor {
    static var shared: AuthProvidor {get}
    var authstate: CurrentValueSubject<AuthState, Never> {get}
    func autoLogin() async
    func login(email: String, password: String) async throws
    func register(email: String, username: String, password: String) async throws
    func logOut() async throws
}

final class AuthManager: AuthProvidor {
    
    private init() {
        Task{ await autoLogin() }
    }
    
    static let shared: AuthProvidor = AuthManager()
    
    var authstate = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authstate.send(.loggedout)
        } else {
            fetchCurrentUser()
        }
    }
    
    func login(email: String, password: String) async throws {
        
    }
    
    func register(email: String, username: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(id: uid, username: username, email: email)
            try await saveUserInfoDatabase(user: newUser)
            self.authstate.send(.loggedin(newUser))
        } catch {
            print("failed to register: \(error.localizedDescription)")
            throw AuthError.failedToRegister(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        
    }
    
    private func saveUserInfoDatabase(user: UserItem) async throws {
        do {
            let userDictionary = ["uid": user.id, "username": user.username, "email": user.email]
            try await Database.database().reference().child("users").child(user.id).setValue(userDictionary)
        }
        catch {
            print("🔐 Failed to save user info into database: \(error.localizedDescription)")
            throw AuthError.failedToSaveData(error.localizedDescription)
        }
    }
}

struct UserItem: Identifiable, Hashable, Codable {
    let id: String
    let username: String
    let email: String
    var bio: String? = "Hey there I'm using whatsapp"
    var profileImageUrl: String? = nil
}

extension AuthManager {
    private func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(currentUid).observe(.value) {[weak self] snapshot in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let loggedInUser = UserItem(dictionary: userDictionary)
            self?.authstate.send(.loggedin(loggedInUser))
            print("🔐\(loggedInUser.username) is logged in")
        } withCancel: { error in
            print("Failed to get current user info")
        }

    }
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
