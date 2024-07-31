//
//  MessageListView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 3/7/24.
//

import SwiftUI

struct MessageListView: UIViewControllerRepresentable {
    
    private let viewModel: ChatRoomViewModel
    
    init(_ viewModel: ChatRoomViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> MessageListController {
        let messageListController = MessageListController(viewModel)
        return messageListController
    }
    
    func updateUIViewController(_ uiViewController: MessageListController, context: Context) {
        
    }
}

#Preview {
    MessageListView(ChatRoomViewModel(.placeholder))
}
