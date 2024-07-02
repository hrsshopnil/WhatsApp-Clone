//
//  SettingsSectionHeader.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct SettingsSectionHeader: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("User Name")
                        .font(.title3)
                    Spacer()
                    
                    Image(.qrcode)
                        .renderingMode(.template)
                        .foregroundStyle(.blue)
                        .padding(5)
                        .background(.black.opacity(0.1))
                        .clipShape(Circle())
                }
                Text("Hey there! I am using whatsapp")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    SettingsSectionHeader()
}
