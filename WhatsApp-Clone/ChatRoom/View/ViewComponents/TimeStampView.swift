//
//  TimeStampView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 5/7/24.
//

import SwiftUI

struct TimeStampView: View {
    let item: MessageItem
    var body: some View {
        HStack {
            Text(item.timeStamp.formatToTime)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    TimeStampView(item: .sentPlaceholder)
}
