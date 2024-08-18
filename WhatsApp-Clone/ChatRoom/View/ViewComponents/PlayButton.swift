//
//  PlayButton.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/7/24.
//

import SwiftUI

struct PlayButton: View {
    let item: MessageItem
    let icon: String
    var body: some View {
        
        Image(systemName: icon)
            .padding(10)
            .background(item.direction == .received ? .green : .white)
            .clipShape(Circle())
            .foregroundStyle(item.direction == .received ? .white : .black)
    }
}

#Preview {
    PlayButton(item: .receivedPlaceholder, icon: "play.fill")
}
