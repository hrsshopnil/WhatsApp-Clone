//
//  MediaPickerItem+Types.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/8/24.
//

import SwiftUI

struct VideoPickerTransferable: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.url)
        } importing: { receivedFile in
            let originalFile = receivedFile.file
            let uniqueFileName = "\(UUID().uuidString).mov"
            let copiedFile = URL.documentsDirectory.appendingPathComponent(uniqueFileName)
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(url: copiedFile)
        }
    }
}

struct MediaAttachment: Identifiable {
    let id: String
    
    let type: MediaAttachmentType
    
    var thumbnail: UIImage {
        switch type {
        case .photo(let thumbnail):
            return thumbnail
        case .audio:
            return UIImage()
        case .video(let thumbnail, _):
            return thumbnail
        }
    }
    
    var fileUrl: URL? {
        switch type {
        case .photo:
            return nil
        case .audio(let voiceUrl, _):
            return voiceUrl
        case .video(_, let fileUrl):
            return fileUrl
        }
    }
}


enum MediaAttachmentType {
    
    case photo(_ thumbnail: UIImage), audio(_ url: URL, _ duration: TimeInterval), video(_ thumbnail: UIImage, url: URL)
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
        case (.photo, .photo), (.video, .video), (.audio, .audio):
            return true
        default:
            return false
        }
    }
}

