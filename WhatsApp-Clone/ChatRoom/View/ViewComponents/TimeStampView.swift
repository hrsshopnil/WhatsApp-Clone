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
                .font(.system(size: 13))
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color(.systemBlue))
            }
        }
    }
}

#Preview {
    TimeStampView(item: .sentPlaceholder)
}
