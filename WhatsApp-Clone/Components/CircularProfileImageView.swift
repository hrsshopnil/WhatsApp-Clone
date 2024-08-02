//
//  CircularProfileImageView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/8/24.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    let profileImageUrl: String?
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .placeholder { ProgressView() }
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        } else {
            placeHolderImageView()
        }
    }
    
    private func placeHolderImageView() -> some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundStyle(Color.placeholder)
            .frame(width: 100, height: 100)
            .background(.white)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProfileImageView(profileImageUrl: nil)
}
