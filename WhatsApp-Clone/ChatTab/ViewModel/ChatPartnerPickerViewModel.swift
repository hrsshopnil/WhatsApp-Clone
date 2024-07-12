//
//  ChatPartnerPickerViewModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation

enum ChatCreationRoute {
    case addGroupChatMember, setUpGroup
}

final class ChatPartnerPickerViewModel: ObservableObject {
    @Published var navStack = [ChatCreationRoute]()
}
