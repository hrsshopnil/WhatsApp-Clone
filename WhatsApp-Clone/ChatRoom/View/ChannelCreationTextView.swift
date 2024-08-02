//
//  ChannelCreationTextView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/8/24.
//

import SwiftUI

struct ChannelCreationTextView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var bgColor: Color {
        return colorScheme == .dark ? .black : .yellow
    }
    var body: some View {
        ZStack {
            (
            Text(Image(systemName: "lock.fill"))
            +
            Text(" Messages and calls are end to end Encrypted, No one outside of this chat, not even Whatsapp, can read or listen to them.")
            +
            Text(" Learn more")
                .bold()
            )
        }
        .font(.footnote)
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(bgColor.opacity(0.6))
        )
        .padding(.horizontal, 30)
    }
}

#Preview {
    ChannelCreationTextView()
}
