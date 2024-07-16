//
//  ChannelTabViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 17/7/24.
//

import Foundation

final class ChannelTabViewModel: ObservableObject {
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    
    func onNewChannelCreation(_ channel: ChannelItem) {
        navigateToChatRoom = true
        newChannel = channel
        showChatPartnerPickerView = false
    }
}
