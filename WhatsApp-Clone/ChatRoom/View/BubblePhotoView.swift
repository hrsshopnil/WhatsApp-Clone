//
//  BubblePhotoView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI
import Kingfisher

struct BubblePhotoView: View {
    let item: MessageItem
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            
            if item.direction == .sent { Spacer() }
            
            if item.showSenderProfile {
                CircularProfileImageView(size: .mini, profileImageUrl: item.sender?.profileImageUrl)
            }
            
            messagePhotoView()
                .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
                .overlay{
                    if item.type == .video {
                        PlayButton(item: item)
                    }
                }
            
            if item.direction == .received { Spacer() }
        }
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
    
    private func messagePhotoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            KFImage(URL(string: item.imageUrl))
                .resizable()
                .placeholder{ ProgressView() }
                .scaledToFill()
                .frame(width: item.imageSize.width, height: item.imageSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(5)
                .overlay(alignment: .bottomTrailing) {
                    TimeStampView(item: item)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(Color(.systemGray3))
                        .clipShape(Capsule())
                        .padding(10)
                }
            if !item.text.isEmptyOrWhiteSpaces {
                Text(item.text)
                    .padding([.horizontal, .bottom], 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(width: item.imageSize.width)
            }
        }
        .background(item.bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .applyTail(item.direction)
    }
    
    private func shareButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "arrowshape.turn.up.right.fill")
                .foregroundStyle(.whatsAppWhite)
                .padding(8)
                .background(.gray)
                .background(.thinMaterial)
                .clipShape(Circle())
            
        }
    }
}

#Preview {
    ScrollView {
        BubblePhotoView(item: .receivedPlaceholder)
    }
    .background(.gray.opacity(0.3))
}
