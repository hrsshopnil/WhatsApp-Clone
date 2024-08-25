//
//  SettingsTabViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 24/8/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine
import Firebase
import AlertKit

@MainActor
final class SettingsTabViewModel: ObservableObject {
    
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var profilePhoto: MediaAttachment?
    @Published var showProgressHUD = false
    @Published var showSuccessHUD = false
    @Published var showUserInfoEditor = false
    @Published var userName = ""
    @Published var bio = ""
    
    private var currentUser: UserItem
    
    private(set) var progressHUDView = AlertAppleMusic17View(title: "Uploading Profile Photo", icon: .spinnerSmall)
    private(set) var successHUDView = AlertAppleMusic17View(title: "Profile Info Updated!", icon: .done)

    private var subscription: AnyCancellable?

    init(_ currentUser: UserItem) {
        self.currentUser = currentUser
        self.userName = currentUser.username
        self.bio = currentUser.bioUnwrapped
        onPhotoSelection()
    }
    
    var disableSaveButton: Bool {
        return selectedPhotoItem == nil || showProgressHUD
    }
    
    private func onPhotoSelection() {
        subscription = $selectedPhotoItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photoItem in
                guard let photoItem else { return }
                self?.parsePhotoItem(photoItem)
            }
    }
    
    private func parsePhotoItem(_ photoItem: PhotosPickerItem) {
        Task {
            guard let data = try? await photoItem.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }
            self.profilePhoto = MediaAttachment(id: UUID().uuidString, type: .photo(uiImage))
        }
    }
    
    func uploadProfilePhoto() {
                
        guard let profilePhoto = profilePhoto?.thumbnail else { return }
        showProgressHUD = true

        FirebaseHelper.uploadImage(profilePhoto, for: .profile) {[weak self] result in
            
            switch result {
                
            case .success(let imageUrl):
                self?.onUploadSuccess(imageUrl)
            case .failure(let error):
                print("Failed to Upload profile to the storage with error: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
        }
    }
    
    private func onUploadSuccess(_ imageUrl: URL) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        FirebaseConstants.UserRef.child(currentId).child(.profileImageUrl).setValue(imageUrl.absoluteString)
        currentUser.profileImageUrl = imageUrl.absoluteString
        AuthManager.shared.authstate.send(.loggedin(currentUser))
        showProgressHUD = false
        progressHUDView.dismiss()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showSuccessHUD = true
            self.selectedPhotoItem = nil
            self.profilePhoto = nil
        }
    }
    
    func updateUserNameBio() {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        var dict: [String: Any] = [.bio: bio]
        currentUser.bio = bio
        
        if !userName.isEmptyOrWhiteSpaces {
            dict[.username] = userName
            currentUser.username = userName
        }
        
        FirebaseConstants.UserRef.child(currentId).updateChildValues(dict)
        showSuccessHUD = true
        AuthManager.shared.authstate.send(.loggedin(currentUser))
    }
}
