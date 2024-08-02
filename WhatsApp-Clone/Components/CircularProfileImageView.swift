//
//  CircularProfileImageView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/8/24.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let size: Size
    let profileImageUrl: String?
    let fallBackImage: FallbackImage
    
    init(size: Size, profileImageUrl: String? = nil) {
        self.size = size
        self.profileImageUrl = profileImageUrl
        self.fallBackImage = .directChannelIcon
    }
    
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .placeholder { ProgressView() }
                .scaledToFit()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            placeHolderImageView()
        }
    }
    
    private func placeHolderImageView() -> some View {
        Image(systemName: fallBackImage.rawValue)
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundStyle(Color.placeholder)
            .frame(width: size.dimension, height: size.dimension)
            .background(.white)
            .clipShape(Circle())
    }
}

extension CircularProfileImageView {
    enum Size {
        case mini, xSmall, small, medium, large, xLarge
        case custom(CGFloat)
        
        var dimension: CGFloat {
            switch self {
            case .mini:
                return 30
            case .xSmall:
                return 40
            case .small:
                return 50
            case .medium:
                return 60
            case .large:
                return 80
            case .xLarge:
                return 120
            case .custom(let dimen):
                return dimen
            }
        }
    }
    
    enum FallbackImage: String {
        case directChannelIcon = "person.circle.fill"
        case groupChannelIcon = "person.2.circle.fill"
        
        init(for memberCount: Int) {
            switch memberCount {
            case 2:
                self = .directChannelIcon
            default:
                self = .groupChannelIcon
            }
        }
    }
}

extension CircularProfileImageView {
    init(_ channel: ChannelItem, size: Size) {
        self.profileImageUrl = channel.coverImageUrl
        self.size = size
        self.fallBackImage = FallbackImage(for: channel.membersCount)
    }
}
#Preview {
    CircularProfileImageView(size: .large)
}
