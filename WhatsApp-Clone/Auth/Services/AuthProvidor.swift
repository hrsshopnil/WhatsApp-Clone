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
    case pending, loggedin, loggedout
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
        
    }
    
    static let shared: AuthProvidor = AuthManager()
    
    var authstate = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authstate.send(.loggedout)
        } else {
            Task { await fetchCurrentUser() }
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
            print("failed to save user info into database: \(error.localizedDescription)")
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
    private func fetchCurrentUser() async {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(currentUid).observe(.value) { snapshot in
            
        } withCancel: { error in
            print("Failed to get current user info")
        }

    }
}
