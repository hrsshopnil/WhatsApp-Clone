//
//  UploadingFileUrl.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 18/8/24.
//

import Foundation

extension ChatRoomViewModel {
    ///Uploads file URL(video, audio) to the Firebase Storage
    func uploadFileToStorage(
        for uploadType: FirebaseHelper.UploadType,
        _ attachment: MediaAttachment,
        completion: @escaping (_ imageURL: URL) -> Void) {

        guard let fileToUpload = attachment.fileUrl else { return }

        FirebaseHelper.uploadFile(fileToUpload, for: uploadType) { result in
            switch result {
            case .success(let videoURL):
                completion(videoURL)

            case .failure(let error):
                print("Failed to upload file to Storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD FILE PROGRESS: \(progress)")
        }
    }
    
    func uploadImageToStorage(_ attachment: MediaAttachment, completion: @escaping(_ imageUrl: URL) -> Void) {
        FirebaseHelper.uploadImage(attachment.thumbnail, for: .photoMessage) { result in
            switch result {
            case .success(let imageUrl):
                completion(imageUrl)
            case .failure(let error):
                print("Failed to upload image: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("Image Uploading Progress: \(progress)")
        }

    }
}
