//
//  CallLinkSectionView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 30/6/24.
//

import SwiftUI

struct CallLinkSectionView: View {
    var body: some View {
        HStack {
            Image(systemName: "link")
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Circle())
                .foregroundStyle(.blue)
            VStack(alignment: .leading) {
                Text("Create a Call Link")
                    .foregroundStyle(.blue)
                Text("Share a link for your whatsapp call")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    CallLinkSectionView()
}
