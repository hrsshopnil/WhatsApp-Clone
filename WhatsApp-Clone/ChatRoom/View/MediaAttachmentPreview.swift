//
//  MediaAttachmentPreview.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 5/8/24.
//

import SwiftUI

struct MediaAttachmentPreview: View {
    let mediaAttachment: [MediaAttachment]
    let actionHandler: (_ action: UserAction) -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(mediaAttachment) { attachment in
                    if attachment.type == .audio(.stubUrl, .stubTimeInterval) {
                        audioAttachmentPreview(attachment)
                    } else {
                        thumbnailImageView(attachment)
                    }
                }
            }
        }
        .frame(height: Constants.listHeight)
        .frame(maxWidth: .infinity)
        .background(.whatsAppWhite)
    }
    
    private func thumbnailImageView(_ attachment: MediaAttachment) -> some View {
        Button {
            
        } label: {
            Image(uiImage: attachment.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageDimen, height: Constants.imageDimen)
                .cornerRadius(5)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    cancelButton(attachment)
                }
                .overlay(alignment: .center){
                    if attachment.type == .video(UIImage(), url: URL(string: "https://google.com")!) {
                        playButton(image: "play.fill", attachment: attachment)
                    }
                }
        }
    }
    
    private func cancelButton(_ attachment: MediaAttachment) -> some View {
        Button {
            actionHandler(.remove(attachment))
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(4)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
    
    private func playButton(image: String, attachment: MediaAttachment) -> some View {
        Button {
            actionHandler(.play(attachment))
        } label: {
            Image(systemName: image)
                .imageScale(.large)
                .foregroundStyle(.white)
                .padding(8)
                .background(.white.opacity(0.5))
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(2)
                .bold()
        }
    }
    
    private func audioAttachmentPreview(_ attachment: MediaAttachment) -> some View {
        ZStack {
            LinearGradient(colors: [.green, .green.opacity(0.8), .teal], startPoint: .topLeading, endPoint: .bottom)
            playButton(image: "mic.fill", attachment: attachment)
                .padding(.bottom, 15)
        }
        .frame(width: Constants.imageDimen * 2, height: Constants.imageDimen)
        .cornerRadius(5)
        .clipped()
        .overlay(alignment: .topTrailing) {
            cancelButton(attachment)
        }
        .overlay(alignment: .bottom) {
            Text(attachment.fileUrl?.absoluteString ?? "")
                .font(.caption)
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding(2)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.white.opacity(0.44))
        }
    }
}

extension MediaAttachmentPreview {
    enum Constants {
        static let listHeight: CGFloat = 100
        static let imageDimen: CGFloat = 80
    }
    
    enum UserAction {
        case play(_ attachment: MediaAttachment)
        case remove(_ attachment: MediaAttachment)
    }
}
#Preview {
    MediaAttachmentPreview(mediaAttachment: []) { action in
        
    }
}
