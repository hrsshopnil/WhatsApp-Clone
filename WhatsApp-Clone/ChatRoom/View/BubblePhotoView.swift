//
//  BubblePhotoView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 4/7/24.
//

import SwiftUI

struct BubblePhotoView: View {
    let item: MessageBubbleItem
    var body: some View {
        Text(item.text)
    }
}

#Preview {
    BubblePhotoView(item: .sentPlaceholder)
}
