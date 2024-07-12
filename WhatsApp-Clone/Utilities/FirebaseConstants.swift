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
    static let userRef = database.child("users")
}
