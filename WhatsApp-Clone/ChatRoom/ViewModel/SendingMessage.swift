//
//  SendingMessage.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 18/8/24.
//

import Foundation

extension ChatRoomViewModel {
    func sendMultipleMediaMessages(_ text: String, attachments: [MediaAttachment]) {
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

     func sendVoiceMessage(text: String, _ attachment: MediaAttachment) {
        
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
}
