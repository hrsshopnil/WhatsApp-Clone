//
//  BubbleAudioView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/7/24.
//

import SwiftUI

struct BubbleAudioView: View {
    let item: MessageItem
    @State private var sliderValue = 0.0
    @State private var sliderRange = 0...20.0
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            if item.showSenderProfile {
                CircularProfileImageView(size: .mini, profileImageUrl: item.sender?.profileImageUrl)
            }
            
            if item.direction == .sent {
                TimeStampView(item: item)
            }
            
            HStack {
                Button {
                    
                } label: {
                    PlayButton(item: item)
                }
                Slider(value: $sliderValue, in: sliderRange)
                    .tint(.gray)
                Text("05:00")
                    .foregroundStyle(.gray)
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(5)
            .background(item.bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .applyTail(item.direction)
            if item.direction == .received {
                TimeStampView(item: item)
            }
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.leadingPadding)
        .padding(.trailing, item.trailingPadding)
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .sentPlaceholder)
        BubbleAudioView(item: .receivedPlaceholder)
    }
    .background(.gray.opacity(0.3))}
