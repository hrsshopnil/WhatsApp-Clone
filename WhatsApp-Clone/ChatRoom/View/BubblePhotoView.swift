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
                if item.direction == .received {shareButton()}
            }
            
            if item.direction == .received {Spacer()}
        }
    }
    
    
    private func messagePhotoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
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
