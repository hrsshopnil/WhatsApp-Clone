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
    case failedToRegister(_ description: String),
         failedToSaveData(_ description: String),
         failedToLogin(_ description: String)
    
    var errorMessage: String? {
        switch self {
            
        case .failedToRegister(let description):
            return description
        case .failedToSaveData(let description):
            return description
        case .failedToLogin(let description):
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
        Task {
            await autoLogin()
        }
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
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUser()
            if let userEmail = authResult.user.email {
                print("Successfully logged in \(userEmail)")
            }
        }
        catch {
            print("failed to login \(email)")
            throw AuthError.failedToLogin(error.localizedDescription)
        }
    }
    
    func register(email: String, username: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(email: email, id: uid, username: username)
            try await saveUserInfoDatabase(user: newUser)
            self.authstate.send(.loggedin(newUser))
        } catch {
            print("failed to register: \(error.localizedDescription)")
            throw AuthError.failedToRegister(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            authstate.send(.loggedout)
            print("Succesfully logged out")
        }
        catch {
            print("failed to log out \(error.localizedDescription)")
        }
    }
}

extension AuthManager {
    
    private func saveUserInfoDatabase(user: UserItem) async throws {
        do {
            let userDictionary: [String: Any] = [.id: user.id, .username: user.username, .email: user.email]
            try await FirebaseConstants.UserRef.child(user.id).setValue(userDictionary)
        }
        catch {
            print("🔐 Failed to save user info into database: \(error.localizedDescription)")
            throw AuthError.failedToSaveData(error.localizedDescription)
        }
    }
    
    private func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        FirebaseConstants.UserRef.child(currentUid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            let loggedInUser = UserItem(dictionary: userDictionary)
            self?.authstate.send(.loggedin(loggedInUser))
            print("🔐\(loggedInUser.username) is logged in")
            
        } withCancel: { error in
            print("Failed to get current user info")
        }
    }
}
