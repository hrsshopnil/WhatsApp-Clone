//
//  RootModel.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 11/7/24.
//

import Foundation
import Combine

final class RootModel: ObservableObject {
    @Published private(set) var authstate = AuthState.pending
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = AuthManager.shared.authstate.receive(on: DispatchQueue.main)
            .sink {[weak self] latestAuthState in
                self?.authstate = latestAuthState
            }
    }
}
