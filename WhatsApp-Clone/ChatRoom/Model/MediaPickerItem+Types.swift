//
//  MediaPickerItem+Types.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/8/24.
//

import SwiftUI

/// A structure that conforms to the `Transferable` protocol, allowing video files to be imported and exported.
///
/// The `VideoPickerTransferable` struct is designed to handle the transfer of video files (with a `.mov` extension) between different parts of an app or between apps. It manages the import and export processes, including copying the file to a specific location in the app's documents directory.
struct VideoPickerTransferable: Transferable {
    
    /// The URL of the video file.
    let url: URL
    
    /// Defines the transfer representation for the video file.
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            // Export the video file by returning its URL.
            return .init(exportingFile.url)
        } importing: { receivedFile in
            // Import the video file by copying it to the app's documents directory with a unique name.
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
    
    case photo(_ thumbnail: UIImage)
    case audio(_ url: URL, _ duration: TimeInterval)
    case video(_ thumbnail: UIImage, url: URL)
    
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
        case (.photo, .photo), (.video, .video), (.audio, .audio):
            return true
        default:
            return false
        }
    }
}

