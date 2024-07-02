//
//  ChatRoomView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 2/7/24.
//

import SwiftUI

struct ChatRoomView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<120) {_ in
                    Text("placeholder")
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Circle()
                        .frame(width: 35, height: 35)
                    Text("User Name")
                        .bold()
                }
            }
            
            ToolbarItemGroup {
                Button {
                    
                } label: {
                    Image(systemName: "video")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "phone")
                }
            }
            
        }
    }
}



#Preview {
    NavigationStack {
        ChatRoomView()
    }
}
