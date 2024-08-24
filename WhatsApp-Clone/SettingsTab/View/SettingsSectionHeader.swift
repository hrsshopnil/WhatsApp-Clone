//
//  SettingsSectionHeader.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI
import PhotosUI

struct SettingsSectionHeader: View {
    
    @ObservedObject var viewModel: SettingsTabViewModel
    let currentUser: UserItem
    
    var body: some View {
        HStack {
            
            if let profilePhoto = viewModel.profilePhoto {
                Image(uiImage: profilePhoto.thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
            } else {
                CircularProfileImageView(size: .custom(55))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(currentUser.username)
                        .font(.title3)
                    Spacer()
                    
                    Image(.qrcode)
                        .renderingMode(.template)
                        .foregroundStyle(.blue)
                        .padding(5)
                        .background(.black.opacity(0.1))
                        .clipShape(Circle())
                }
                Text(currentUser.bioUnwrapped)
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    SettingsSectionHeader(viewModel: SettingsTabViewModel(), currentUser: .placeHolder)
}
