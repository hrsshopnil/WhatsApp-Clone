//
//  BubbleTailView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI

struct BubbleTailView: View {
    
    var direction: MessageDirection
    
    private var bgColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    var body: some View {
        Image(direction == .sent ? .outgoingTail : .incomingTail)
            .renderingMode(.template)
            .resizable()
            .frame(width: 10, height: 10)
            .offset(y: 3)
            .foregroundStyle(bgColor)
    }
}

#Preview {
    VStack {
        BubbleTailView(direction: .sent)
        BubbleTailView(direction: .received)
    }
}
