//
//  FirebaseHelper.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 14/8/24.
//

import Foundation
import SwiftUI

typealias UploadCompletion = (Result<URL, Error>) -> Void
typealias ProgressHandler = (Double) -> Void
struct FirebaseHelper {
    static func uploadImage(_ image: UIImage,
                            for type: UploadType,
                            completion: @escaping UploadCompletion,
                            progressHandler: @escaping ProgressHandler) {
        
    }
}

extension FirebaseHelper {
    enum UploadType {
        case profile, photoMessage, videoMessage, audioMessage
    }
}
