//
//  FirebaseConstants.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseConstants {
    private static let database = Database.database().reference()
    static let UserRef = database.child("users")
    static let ChannelsRef = database.child("channels")
    static let MessageRef = database.child("channel-messages")
    static let UserChannelRef = database.child("user-channels")
    static let UserDirectChannels = database.child("user-direct-channels")
}
