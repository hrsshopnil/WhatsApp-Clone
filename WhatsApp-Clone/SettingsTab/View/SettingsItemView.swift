//
//  SettingsItemView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct SettingsItemView: View {
    let item: SettingsItem
    var body: some View {
        HStack  {
            iconImageView()
                .frame(width: 30, height: 30)
                .background(item.backgroundColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            
            Text(item.title)
                .font(.system(size: 18))
            Spacer()
        }
    }
    
    @ViewBuilder
    private func iconImageView() -> some View {
        switch item.imageType {
        case .systemImage:
            Image(systemName: item.imageName)
                .font(.callout)
                .bold()
        case .assetImage:
            Image(item.imageName)
                .renderingMode(.template)
                .padding(3)
        }
    }
}

#Preview {
    SettingsItemView(item: .chats)
}
