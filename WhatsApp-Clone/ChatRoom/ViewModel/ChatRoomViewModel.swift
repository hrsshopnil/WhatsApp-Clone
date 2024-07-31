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
    @Published var currenUser: UserItem?
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
        AuthManager.shared.authstate.receive(on: DispatchQueue.main).sink { authstate in
            switch authstate {
            case .loggedin(let currenUser):
                self.currenUser = currenUser
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
}
