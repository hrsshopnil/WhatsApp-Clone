//
//  FirebaseHelper.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 14/8/24.
//

import Foundation
import SwiftUI
import FirebaseStorage

typealias UploadCompletion = (Result<URL, Error>) -> Void
typealias ProgressHandler = (Double) -> Void

enum UploadError: Error {
    case failedToUploadImage(_ description: String), failedToUploadFileUrl(_ description: String)
    
    var errorMessage: String? {
        switch self {
        case .failedToUploadImage(let description):
            return description
        case .failedToUploadFileUrl(let description):
            return description
        }
    }
}

struct FirebaseHelper {
    
    // MARK:  Responsible for uploading Image like Profile image and Photo message to the firebase Storage
    static func uploadImage(_ image: UIImage,
                            for type: UploadType,
                            completion: @escaping UploadCompletion,
                            progressHandler: @escaping ProgressHandler) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        ///Firebase Location to store the file
        let storageRef = type.filePath
        
        /// Uploads the file
        let uploadTask = storageRef.putData(imageData) { _, error in
            if let error = error {
                print("Failed to upload image on the firebase storage: \(error.localizedDescription)")
                completion(.failure(UploadError.failedToUploadImage(error.localizedDescription)))
                return
            }
            
            ///Download the url of the uploaded file
            storageRef.downloadURL(completion: completion)
        }
        
        ///Gets the progression of uploading the file and assigns it to the progressHandler
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
    
    // MARK: Responsible for uploading File like Video and Audio messages to the Firebase Storage
    static func uploadFile(_ fileUrl: URL,
                            for type: UploadType,
                            completion: @escaping UploadCompletion,
                            progressHandler: @escaping ProgressHandler) {
        
        ///Firebase Location to store the file
        let storageRef = type.filePath
        
        /// Uploads the file
        let uploadTask = storageRef.putFile(from: fileUrl) { _, error in
            if let error = error {
                print("Failed to upload File Url on the firebase storage: \(error.localizedDescription)")
                completion(.failure(UploadError.failedToUploadFileUrl(error.localizedDescription)))
                return
            }
            ///Download the url of the uploaded file
            storageRef.downloadURL(completion: completion)
        }
        
        ///Gets the progression of uploading the file and assigns it to the progressHandler
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            progressHandler(percentage)
        }
    }
}

extension FirebaseHelper {
    enum UploadType {
        case profile, photoMessage, videoMessage, voiceMessage
        
        var filePath: StorageReference {
            let fileName = UUID().uuidString
            switch self {
            case .profile:
                return FirebaseConstants.ProfileImageRef.child(fileName)
            case .photoMessage:
                return FirebaseConstants.PhotoMessageRef.child(fileName)
            case .videoMessage:
                return FirebaseConstants.VideoMessageRef.child(fileName)
            case .voiceMessage:
                return FirebaseConstants.VoiceMessageRef.child(fileName)
            }
        }
    }
}
