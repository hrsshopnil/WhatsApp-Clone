//
//  BubbleAudioView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/7/24.
//

import SwiftUI

struct BubbleAudioView: View {
    let item: MessageBubbleItem
    @State private var sliderValue = 0.0
    @State private var sliderRange = 0...20.0
    var body: some View {
        VStack(alignment: item.horizontalAlignment, spacing: 3) {
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
            TimeStampView(item: item)
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .received ? 5 : 100)
        .padding(.trailing, item.direction == .received ? 100 : 5)
    }
}

#Preview {
    ScrollView {
        BubbleAudioView(item: .sentPlaceholder)
        BubbleAudioView(item: .receivedPlaceholder)
    }
    .padding()
}