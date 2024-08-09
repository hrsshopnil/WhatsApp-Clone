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

/// A structure representing a media attachment, which could be a photo, audio, or video.
struct MediaAttachment: Identifiable {
    /// The unique identifier for the media attachment.
    let id: String
    
    /// The type of the media attachment, which determines its content and behavior.
    let type: MediaAttachmentType
    
    /// A thumbnail image representing the media attachment.
    ///
    /// - Returns:
    ///     - For a photo, the thumbnail of the photo.
    ///     - For an audio file, a default empty `UIImage`.
    ///     - For a video, the thumbnail of the video.
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
    
    /// The URL of the file associated with the media attachment, if applicable.
    ///
    /// - Returns:
    ///     - `nil` for photos and audio files.
    ///     - The file URL for a video.
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


/// An enumeration representing different types of media attachments.
enum MediaAttachmentType {
    
    /// A case representing a photo attachment with an associated thumbnail image.
    /// - Parameter thumbnail: A `UIImage` representing the thumbnail of the photo.
    case photo(_ thumbnail: UIImage), audio, video(_ thumbnail: UIImage, url: URL)
    
    /// Compares two `MediaAttachmentType` instances for equality.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `MediaAttachmentType` instance.
    ///   - rhs: The right-hand side `MediaAttachmentType` instance.
    /// - Returns: A Boolean value indicating whether the two instances are of the same type.
    ///
    /// The comparison checks if both instances are of the same case (e.g., both are `.photo`, `.audio`, or `.video`).
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
        case (.photo, .photo), (.video, .video), (.audio, .audio):
            return true
        default:
            return false
        }
    }
}

