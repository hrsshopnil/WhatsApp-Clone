//
//  AuthProvidor.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 9/7/24.
//

import Foundation
import Combine

enum AuthState {
    case pending, loggedin, loggedout
}

protocol AuthProvidor {
    static var shared: AuthProvidor {get}
    var authstate: CurrentValueSubject<AuthState, Never> {get}
    func autoLogin() async
    func login(email: String, password: String) async throws
    func register(email: String, username: String, password: String) async throws
    func logOut() async throws
}
