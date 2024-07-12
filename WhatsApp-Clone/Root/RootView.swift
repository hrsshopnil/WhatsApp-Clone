//
//  RootView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 11/7/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewmodel = RootModel()
    var body: some View {
        switch viewmodel.authstate {
        case .pending:
            ProgressView()
                .controlSize(.large)
        case .loggedin(let user):
            MainTabView(user)
        case .loggedout:
            LoginView()
        }
    }
}

#Preview {
    RootView()
}
