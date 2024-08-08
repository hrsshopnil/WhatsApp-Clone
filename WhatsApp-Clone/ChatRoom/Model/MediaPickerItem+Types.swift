//
//  MediaPickerItem+Types.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 6/8/24.
//

import SwiftUI

/// A structure representing a transferable video file.
struct VideoPickerTransferable: Transferable {
    
    /// The URL of the video file.
    let url: URL

    /// Provides the transfer representation for the video file, including export and import logic.
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            /// Closure for exporting the video file.
            /// - Parameter exportingFile: The file being exported.
            /// - Returns: An instance initialized with the URL of the exporting file.
            return .init(exportingFile.url)
        } importing: { receivedTransferredFile in
            /// Closure for importing the video file.
            /// - Parameter receivedTransferredFile: The file being imported.
            /// - Returns: An instance initialized with the URL of the copied file.
            let originalFile = receivedTransferredFile.file
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
        case .audio:
            return nil
        case .video(_, let fileUrl):
            return fileUrl
        }
    }
}

enum MediaAttachmentType {
    case photo(_ thumbnail: UIImage), audio, video(_ thumbnail: UIImage, url: URL)
    
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
        case (.photo, .photo), (.video, .video), (.audio, .audio):
            return true
        default:
            return false
        }
    }
}
