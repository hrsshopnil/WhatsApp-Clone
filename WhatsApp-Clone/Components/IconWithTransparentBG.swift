//
//  SwiftUIView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 12/7/24.
//

import SwiftUI

struct IconWithTransparentBG: View {
    let imageName: String
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: imageName)
                .padding(12)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray5))
                .fontWeight(.semibold)
                .clipShape(Circle())
        }
    }
}
#Preview {
    IconWithTransparentBG(imageName: "book.fill")
}
