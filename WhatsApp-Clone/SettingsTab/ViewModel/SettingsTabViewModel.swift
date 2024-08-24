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

@MainActor
final class SettingsTabViewModel: ObservableObject {
    
    @Published var selectedPhotoItem: PhotosPickerItem?
    @Published var profilePhoto: MediaAttachment?
    private var subscription: AnyCancellable?
    
    init() {
        onPhotoSelection()
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
}
