//
//  MediaAttachmentPreview.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 5/8/24.
//

import SwiftUI

struct MediaAttachmentPreview: View {
    let mediaAttachment: [MediaAttachment]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                audioAttachmentPreview()
                ForEach(mediaAttachment) { attachment in
                    thumbnailImage(attachment: attachment.thumbnail)
                        .overlay {
                            playButton(image: "play.fill")
                        }
                }
            }
        }
        .frame(height: Constants.listHeight)
        .frame(maxWidth: .infinity)
        .background(.whatsAppWhite)
    }
    
    private func thumbnailImage(attachment: UIImage) -> some View {
        Button {
            
        } label: {
            Image(uiImage: attachment)
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageDimen, height: Constants.imageDimen)
                .cornerRadius(5)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    cancelButton()
                }
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            
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
    
    private func playButton(image: String) -> some View {
        Button {
            
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
    
    private func audioAttachmentPreview() -> some View {
        ZStack {
            LinearGradient(colors: [.green, .green.opacity(0.8), .teal], startPoint: .topLeading, endPoint: .bottom)
                playButton(image: "mic.fill")
                .padding(.bottom, 15)
        }
        .frame(width: Constants.imageDimen * 2, height: Constants.imageDimen)
        .cornerRadius(5)
        .clipped()
        .overlay(alignment: .topTrailing) {
            cancelButton()
        }
        .overlay(alignment: .bottom) {
            Text("Test Mp3 file name here")
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
}
#Preview {
    MediaAttachmentPreview(mediaAttachment: [])
}
