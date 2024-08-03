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
    private(set) var channel: ChannelItem
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
                self?.fetchAllChannelMembers()
            default:
                break
            }
        }.store(in: &subscription)
    }
    
    func sendMessage() {
        guard let currenUser else { return }
        MessageService.sendTextMessage(to: channel, from: currenUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(channel) {[weak self] messages in
            self?.messages = messages
            print(messages.map {$0.text})
        }
    }
    
    private func fetchAllChannelMembers() {
        guard let currenUser else { return }
        var membersUids = channel.membersUids.compactMap {$0}
        membersUids = membersUids.filter {$0 != currenUser.id}
        UserService.getUsers(with: membersUids) { [weak self] usernode in
            print(usernode)
            guard let self = self else { return }
            self.channel.members.append(contentsOf: usernode.users)
            self.getMessages()
            print("GetChannelMembers: \(channel.members.map { $0.username })")
        }
    }
}
