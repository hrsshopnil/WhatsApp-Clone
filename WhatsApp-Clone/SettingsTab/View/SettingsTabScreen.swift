//
//  SettingsTabScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI
import PhotosUI

struct SettingsTabScreen: View {
    
    @State private var searchText = ""
    @StateObject private var viewModel = SettingsTabViewModel()
    let currentUser: UserItem
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingsSectionHeader(viewModel: viewModel, currentUser: currentUser)
                    PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .not(.videos)) {
                        SettingsItemView(item: .avatar)
                    }
                }
                
                Section {
                    SettingsItemView(item: .broadCastLists)
                    SettingsItemView(item: .starredMessages)
                    SettingsItemView(item: .linkedDevices)
                }
                
                Section {
                    SettingsItemView(item: .account)
                    SettingsItemView(item: .privacy)
                    SettingsItemView(item: .notifications)
                    SettingsItemView(item: .chats)
                    SettingsItemView(item: .storage)
                }
                
                Section {
                    SettingsItemView(item: .help)
                    SettingsItemView(item: .tellFriend)
                }
                Button {
                    Task {
                        try? await AuthManager.shared.logOut()
                    }
                } label: {
                    Text("Log Out")
                        .foregroundStyle(.red)
                }

            }
            .navigationTitle("Settings")
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    SettingsTabScreen(currentUser: .placeHolder)
}
