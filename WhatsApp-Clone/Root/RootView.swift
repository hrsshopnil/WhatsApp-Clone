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
                .onAppear {
                    print("Progress view: \(viewmodel.authstate)")
                }
        case .loggedin(let user):
            MainTabView(user)
                .onAppear {
                    print("main tab view: \(viewmodel.authstate)")
                }
        case .loggedout:
            LoginView()
                .onAppear {
                    print("login view: \(viewmodel.authstate)")
                }
        }
    }
}

#Preview {
    RootView()
}
