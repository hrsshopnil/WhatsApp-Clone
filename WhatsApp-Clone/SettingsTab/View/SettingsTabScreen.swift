//
//  SettingsTabScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI
import PhotosUI

struct SettingsTabScreen: View {
    let currentUser: UserItem
    @State private var searchText = ""
    @StateObject private var viewModel: SettingsTabViewModel
    
    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        self._viewModel = StateObject(wrappedValue: SettingsTabViewModel(currentUser))
    }
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
            .toolbar {
               saveButton()
            }
            .alert(isPresent: $viewModel.showProgressHUD, view: viewModel.progressHUDView)
            .alert(isPresent: $viewModel.showSuccessHUD, view: viewModel.successHUDView)
            .alert("Update Your Profile", isPresented: $viewModel.showUserInfoEditor) {
                TextField("Username", text: $viewModel.userName)
                TextField("Bio", text: $viewModel.bio)
                Button("Update") { viewModel.updateUserNameBio() }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
}

extension SettingsTabScreen {
    @ToolbarContentBuilder
    private func saveButton() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Save") {
                viewModel.uploadProfilePhoto()
            }
            .bold()
            .disabled(viewModel.disableSaveButton)
        }
    }
}
#Preview {
    SettingsTabScreen(.placeHolder)
}
