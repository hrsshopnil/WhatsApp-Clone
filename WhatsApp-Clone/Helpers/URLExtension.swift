//
//  URLExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/8/24.
//

import Foundation
import AVFoundation
import UIKit

extension URL {
    func generateVideoThumbnail() async throws -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        return try await withCheckedThrowingContinuation { continuation in
            imageGenerator.generateCGImageAsynchronously(for: time) { cgImage, _, error in
                if let cgImage = cgImage {
                    let thumbnailImage = UIImage(cgImage: cgImage)
                    continuation.resume(returning: thumbnailImage)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    static var stubUrl: URL {
        return URL(fileURLWithPath: "")
    }
}
