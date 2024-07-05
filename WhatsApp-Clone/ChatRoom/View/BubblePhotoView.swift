//
//  BubblePhotoView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI

struct BubblePhotoView: View {
    let item: MessageBubbleItem
    var body: some View {
        HStack {
            if item.direction == .sent {Spacer()}
            
            HStack {
                if item.direction == .sent {shareButton()}
                messagePhotoView()
                    .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
                    .overlay{
                        if item.type == .video {
                            playButton()
                        }
                    }
                if item.direction == .received {shareButton()}
            }
            
            if item.direction == .received {Spacer()}
        }
    }
    
    private func playButton() -> some View {
        Image(systemName: "play.fill")
            .padding()
            .imageScale(.large)
            .foregroundStyle(.gray)
            .background(.thinMaterial)
            .clipShape(Circle())
    }
    
    private func messagePhotoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(.stubImage0)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 180)
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
            Text(item.text)
                .padding([.horizontal, .bottom], 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: 220)
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
    BubblePhotoView(item: .sentPlaceholder)
}
