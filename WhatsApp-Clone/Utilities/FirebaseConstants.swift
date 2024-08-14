//
//  FirebaseConstants.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabaseInternal

class FirebaseConstants {
    private static let database = Database.database().reference()
    static let UserRef = database.child("users")
    static let ChannelsRef = database.child("channels")
    static let MessageRef = database.child("channel-messages")
    static let UserChannelRef = database.child("user-channels")
    static let UserDirectChannels = database.child("user-direct-channels")
    
    private static let storage = Storage.storage().reference()
    static let ProfileImageRef = storage.child("profile_image_urls")
    static let PhotoMessageRef = storage.child("photo_messages")
    static let VideoMessageRef = storage.child("video_messages")
    static let VoiceMessageRef = storage.child("voice_messages")
}
