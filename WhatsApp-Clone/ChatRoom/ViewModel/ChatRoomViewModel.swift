//
//  ChatRoomViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 31/7/24.
//

import Foundation
import Combine

final class ChatRoomViewModel: ObservableObject {
    @Published var textMessage = ""
    @Published var messages = [MessageItem]()
    private var currenUser: UserItem?
    private var channel: ChannelItem
    private var subscription = Set<AnyCancellable>()
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
    }
    
    deinit {
        subscription.forEach {$0.cancel()}
        subscription.removeAll()
        currenUser = nil
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authstate.receive(on: DispatchQueue.main).sink {[weak self] authstate in
            switch authstate {
            case .loggedin(let currenUser):
                self?.currenUser = currenUser
                self?.getMessages()
            default:
                break
            }
        }.store(in: &subscription)
    }
    
    func messageSent() {
        guard let currenUser else { return }
        MessageService.sendTextMessage(to: channel, from: currenUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(channel) {[weak self] messages in
            self?.messages = messages
            print("Messages: \(messages.map {$0.text})")
        }
    }
}
