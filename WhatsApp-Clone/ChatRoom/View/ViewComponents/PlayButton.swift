//
//  PlayButton.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/7/24.
//

import SwiftUI

struct PlayButton: View {
    let item: MessageBubbleItem
    var body: some View {
        
        Image(systemName: "play.fill")
            .padding(10)
            .background(item.direction == .received ? .green : .white)
            .clipShape(Circle())
            .foregroundStyle(item.direction == .received ? .white : .black)
    }
}

#Preview {
    PlayButton(item: .receivedPlaceholder)
}
