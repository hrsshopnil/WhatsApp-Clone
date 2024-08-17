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
    @Published var isRecording = false
    @Published var timeInterval: TimeInterval = 0
    @Published var scrollToBottom: (scroll: Bool, isAnimated: Bool) = (false, false)
    
    private var currentUser: UserItem?
    private(set) var channel: ChannelItem
    private var subscription = Set<AnyCancellable>()
    private var voiceRecorderService = VoiceRecorderService()
    
    var showPhotoPickerPreview: Bool {
        return !photoPickerItems.isEmpty || !mediaAttachments.isEmpty
    }
    
    var disableButton: Bool {
        return mediaAttachments.isEmpty && textMessage.isEmptyOrWhiteSpaces
    }
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotosSelection()
        setupVoiceRecorderListener()
    }
    
    deinit {
        subscription.forEach { $0.cancel() }
        subscription.removeAll()
        currentUser = nil
        voiceRecorderService.tearDown()
    }
    
    ///Continuously listens to Current User's email and stores it in the Subscription variable
    private func listenToAuthState() {
        AuthManager.shared.authstate.receive(on: DispatchQueue.main).sink {[weak self] authstate in
            switch authstate {
            case .loggedin(let currenUser):
                self?.currentUser = currenUser
                self?.fetchAllChannelMembers()
            default:
                break
            }
        }.store(in: &subscription)
    }
    
    ///Continuously listens whether voice recorder is active or not and timelapse and stores the value in the Subscription variable
    private func setupVoiceRecorderListener() {
        voiceRecorderService.$isRecording.receive(on: DispatchQueue.main).sink { [weak self] isRecording in
            self?.isRecording = isRecording
        }.store(in: &subscription)
        
        voiceRecorderService.$elapsedTime.receive(on: DispatchQueue.main).sink { [weak self] elapsedTime in
            self?.timeInterval = elapsedTime
        }.store(in: &subscription)
    }
    
    ///Final Function to send a message
    func sendMessage() {
        guard let currentUser else { return }
        if mediaAttachments.isEmpty {
            MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) {[weak self] in
                self?.textMessage = ""
            }
        } else {
            sendMultipleMediaMessages(textMessage, attachments: mediaAttachments)
            clearTextInputArea()
        }
    }
    
    ///Clears the text input area and dismisses the keyboard after a message is being sent
    private func clearTextInputArea() {
        mediaAttachments.removeAll()
        photoPickerItems.removeAll()
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    private func sendMultipleMediaMessages(_ text: String, attachments: [MediaAttachment]) {
        attachments.forEach { attachment in
            switch attachment.type {
                
            case .photo:
                sendPhotoMessage(text: text, attachment)
            case .audio:
                sendVoiceMessage(text: text, attachment)
            case .video:
                sendVideoMessage(text: text, attachment)
            }
        }
    }
    
    private func sendVideoMessage(text: String, _ attachment: MediaAttachment) {
        /// Uploads the video file to the storage bucket
        uploadFileToStorage(for: .videoMessage, attachment) { [weak self] videoURL in

            /// Upload the video thumbnail
            self?.uploadImageToStorage(attachment) { [weak self] thumbnailURL in
                guard let self = self, let currentUser else { return }

                let uploadParams = MessageUploadParams(
                    channel: self.channel,
                    text: text,
                    type: .video,
                    attachment: attachment,
                    thumbnailUrl: thumbnailURL.absoluteString,
                    videoUrl: videoURL.absoluteString,
                    sender: currentUser
                )

                /// Saves the metadata to the realtime database
                MessageService.sendMediaMessage(to: self.channel, params: uploadParams) { [weak self] in
                    self?.scrollToBottom(isAnimated: true)
                }
            }
        }
    }

    private func sendVoiceMessage(text: String, _ attachment: MediaAttachment) {
        
        guard let audioDuration = attachment.audioDuration, let currentUser else { return }
        
        uploadFileToStorage(for: .voiceMessage, attachment) {[weak self] fileUrl in
            guard let self else { return }
            
            let uploadParams = MessageUploadParams(
                channel: self.channel,
                text: text,
                type: .audio,
                attachment: attachment,
                sender: currentUser,
                audioUrl: fileUrl.absoluteString,
                audioDuration: audioDuration
            )
            
            ///Saves the metadata and url to the realtime database
            MessageService.sendMediaMessage(to: self.channel, params: uploadParams) {[weak self] in
                self?.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    ///Uploads file URL(video, audio) to the Firebase Storage
    private func uploadFileToStorage(
        for uploadType: FirebaseHelper.UploadType,
        _ attachment: MediaAttachment,
        completion: @escaping (_ imageURL: URL) -> Void) {

        guard let fileToUpload = attachment.fileUrl else { return }

        FirebaseHelper.uploadFile(fileToUpload, for: uploadType) { result in
            switch result {
            case .success(let videoURL):
                completion(videoURL)

            case .failure(let error):
                print("Failed to upload file to Storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD FILE PROGRESS: \(progress)")
        }
    }

    
    private func sendPhotoMessage(text: String, _ attachment: MediaAttachment) {
        uploadImageToStorage(attachment) {[weak self] imageUrl in
            guard let self, let currentUser else { return }
            
            let uploadParams = MessageUploadParams(channel: channel,
                                                   text: text,
                                                   type: .photo,
                                                   attachment: attachment,
                                                   thumbnailUrl: imageUrl.absoluteString,
                                                   sender: currentUser)
            
            MessageService.sendMediaMessage(to: channel, params: uploadParams) {
                self.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    private func uploadImageToStorage(_ attachment: MediaAttachment, completion: @escaping(_ imageUrl: URL) -> Void) {
        FirebaseHelper.uploadImage(attachment.thumbnail, for: .photoMessage) { result in
            switch result {
            case .success(let imageUrl):
                completion(imageUrl)
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("Image Uploading Progress: \(progress)")
        }

    }
    
    ///Scroll the the bottom of a chatroom after a message is sent
    private func scrollToBottom(isAnimated: Bool) {
        scrollToBottom.scroll = true
        scrollToBottom.isAnimated = isAnimated
    }
    
    
    private func getMessages() {
        MessageService.getMessages(channel) {[weak self] messages in
            self?.messages = messages
        }
    }
    
    ///Fetches all the members of a channel
    private func fetchAllChannelMembers() {
        guard let currentUser else { return }
        var membersUids = channel.membersUids.compactMap {$0}
        membersUids = membersUids.filter {$0 != currentUser.id}
        UserService.getUsers(with: membersUids) { [weak self] usernode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: usernode.users)
            self.channel.members.append(currentUser)
            self.getMessages()
        }
    }
    
    func handleAction(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            sendMessage()
        case .recordingAudio:
            toggleAudioRecorder()
        }
    }
    
    /// Decides whether to start recording audio or stop recording audio
    private func toggleAudioRecorder() {
        if voiceRecorderService.isRecording {
            voiceRecorderService.stopRecording {[weak self] audioUrl, audioDuration in
                self?.createAudioAttachment(from: audioUrl, audioDuration)
            }
        } else {
            voiceRecorderService.startRecording()
        }
    }
    
    ///Creates th audio Url and inserts it to the mediaAttachment
    private func createAudioAttachment(from audioUrl: URL? , _ audioDuration: TimeInterval) {
        guard let audioUrl else { return }
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioUrl, audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    private func onPhotosSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self else { return }
            let recording = mediaAttachments.filter { $0.type == .audio(.stubUrl, .stubTimeInterval) }
            self.mediaAttachments = recording
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
    
    // Works for play and the cancel button of the selected media item
    ///.play: Plays the Video or shows the photo
    ///.remove: Removes the media from the picker and filemanager
    func handleMediaAttachmentPreview(_ action: MediaAttachmentPreview.UserAction) {
        switch action {
        case .play(let attachment):
            guard let fileUrl = attachment.fileUrl else { return }
            showMediaPlayer(fileUrl)
        case .remove(let attachment):
            remove(attachment)
            guard let fileUrl = attachment.fileUrl else { return }
            if attachment.type == .audio(.stubUrl, .stubTimeInterval) {
                voiceRecorderService.deleteRecording(at: fileUrl)
            }
        }
    }
    
    /// Removes a media from the file manager of the phone
    private func remove(_ item: MediaAttachment) {
        guard let attachmentIndex = mediaAttachments.firstIndex(where: { $0.id == item.id }) else { return }
                mediaAttachments.remove(at: attachmentIndex)
                
        guard let photoIndex = photoPickerItems.firstIndex(where: { $0.itemIdentifier == item.id }) else { return}
                        photoPickerItems.remove(at: photoIndex)
    }
}
