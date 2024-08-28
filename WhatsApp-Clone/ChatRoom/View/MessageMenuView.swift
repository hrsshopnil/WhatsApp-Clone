//
//  MessageMenuView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 28/8/24.
//

import SwiftUI

struct MessageMenuView: View {
    let message: MessageItem
    @State private var animatingBGView = false
    var body: some View {
        VStack(spacing: 10) {
            ForEach(MessagesMenuAction.allCases) { action in
               buttonBody(action)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(action == .delete ? .red : .whatsAppBlack)
                
                if action != .delete {
                    Divider()
                }
            }
        }
        .frame(width: message.imageWidth)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 0)
        .scaleEffect(animatingBGView ? 1 : 0, anchor: message.menuAnchor)
        .opacity(animatingBGView ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.2)) {
                animatingBGView = true
            }
        }
    }
    
    private func buttonBody(_ action: MessagesMenuAction) -> some View {
        Button {
            
        } label: {
            HStack {
                Text(action.rawValue.capitalized)
                Spacer()
                Image(systemName: action.systemImage)
            }
            .padding()
        }
    }
}

#Preview {
    MessageMenuView(message: .sentPlaceholder)
}
