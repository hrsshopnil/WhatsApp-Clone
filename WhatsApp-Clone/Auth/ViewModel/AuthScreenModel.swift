//
//  AuthScreenModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 8/7/24.
//

import Foundation

final class AuthScreenModel: ObservableObject {
    
    // MARK: Published Properties
    @Published var isLoading = false
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var errorstate: (showError: Bool, errorMessage: String) = (false, "uh oh")
    
    // MARK: Computed Properties
    var disabledLoginButton: Bool {
        email.isEmpty || password.isEmpty || isLoading || email.contains(" ") || password.count < 6 || !email.contains("@")
    }
    
    var disabledRegisterButton: Bool {
        email.isEmpty || password.isEmpty || username.isEmpty || isLoading || email.contains(" ") || password.count < 6 || !email.contains("@")
    }
    
    func handleSignIn() async {
        isLoading = true
        do {
            try await AuthManager.shared.register(email: email, username: username, password: password)
        } catch {
            errorstate.errorMessage = "Failed to create accoung \(error.localizedDescription)"
            errorstate.showError = true
            isLoading = false
        }
    }
}
