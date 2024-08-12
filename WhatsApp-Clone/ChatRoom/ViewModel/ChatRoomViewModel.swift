//
//  ChatRoomViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/7/24.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI
import AVKit

final class ChatRoomViewModel: ObservableObject {
    @Published var textMessage = ""
    @Published var messages = [MessageItem]()
    @Published var showPhotoPicker = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var mediaAttachments: [MediaAttachment] = []
    @Published var videoPlayerState: (show: Bool, player: AVPlayer?) = (false, nil)
    
    private var currenUser: UserItem?
    private(set) var channel: ChannelItem
    private var subscription = Set<AnyCancellable>()
    
    var showPhotoPickerPreview: Bool {
        return !photoPickerItems.isEmpty || !mediaAttachments.isEmpty
    }
    
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotosSelection()
    }
    
    deinit {
        subscription.forEach {$0.cancel()}
        subscription.removeAll()
        currenUser = nil
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authstate.receive(on: DispatchQueue.main).sink {[weak self] authstate in
            switch authstate {
            case .loggedin(let currenUser):
                self?.currenUser = currenUser
                self?.fetchAllChannelMembers()
            default:
                break
            }
        }.store(in: &subscription)
    }
    
    func sendMessage() {
        guard let currenUser else { return }
        MessageService.sendTextMessage(to: channel, from: currenUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(channel) {[weak self] messages in
            self?.messages = messages
        }
    }
    
    private func fetchAllChannelMembers() {
        guard let currenUser else { return }
        var membersUids = channel.membersUids.compactMap {$0}
        membersUids = membersUids.filter {$0 != currenUser.id}
        UserService.getUsers(with: membersUids) { [weak self] usernode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: usernode.users)
            self.channel.members.append(currenUser)
            self.getMessages()
        }
    }
    
    func handleAction(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            sendMessage()
        }
    }
    
    private func onPhotosSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self else { return }
            mediaAttachments.removeAll()
            Task {
                for photoItem in photoItems {
                    if photoItem.isVideo {
                        if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self), let thumbnailImage = try? await movie.url.generateVideoThumbnail(),
                           let id = photoItem.itemIdentifier {
                            let videoAttachment = MediaAttachment(id: id, type: .video(thumbnailImage, url: movie.url))
                            self.mediaAttachments.insert(videoAttachment, at: 0)
                        }
                    }
                    else {
                        guard
                            let data = try? await photoItem.loadTransferable(type: Data.self),
                            let uiImage = UIImage(data: data),
                            let id = photoItem.itemIdentifier  else { return }
                        let photosAttachment = MediaAttachment(id: id, type: .photo(uiImage))
                        self.mediaAttachments.insert(photosAttachment, at: 0)
                    }
                }
            }
        }.store(in: &subscription)
    }
    
    func dismissMediaPlayer() {
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
    }
    
    func showMediaPlayer(_ fileUrl: URL) {
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileUrl)
    }
    
    func handleMediaAttachmentPreview(_ action: MediaAttachmentPreview.UserAction) {
        switch action {
        case .play(let attachment):
            guard let fileUrl = attachment.fileUrl else { return }
            showMediaPlayer(fileUrl)
        case .remove(let attachment):
            remove(attachment)
        }
    }
    
    private func remove(_ item: MediaAttachment) {
        guard let attachmentIndex = mediaAttachments.firstIndex(where: { $0.id == item.id }) else { return }
                mediaAttachments.remove(at: attachmentIndex)
                
        guard let photoIndex = photoPickerItems.firstIndex(where: { $0.itemIdentifier == item.id }) else { return}
                        photoPickerItems.remove(at: photoIndex)
    }
}
