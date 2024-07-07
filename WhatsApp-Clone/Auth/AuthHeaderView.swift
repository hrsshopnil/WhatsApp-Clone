//
//  AuthHeaderView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 7/7/24.
//

import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
        HStack {
            Image(.whatsapp)
                .resizable()
                .frame(width: 40, height: 40)
            Text("WhatsApp")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    AuthHeaderView()
}
