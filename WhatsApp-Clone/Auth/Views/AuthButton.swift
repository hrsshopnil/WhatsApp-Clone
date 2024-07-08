//
//  AuthButton.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 7/7/24.
//

import SwiftUI

struct AuthButton: View {
    let title: String
    let onTab: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    
    private var bgColor: Color {
        return isEnabled ? Color.white : Color.white.opacity(0.2)
    }
    
    private var textColor: Color {
        return isEnabled ? Color.green : Color.white
    }
    var body: some View {
        Button {
           onTab()
        } label: {
            HStack {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .green.opacity(0.2), radius: 10)
        }

    }
}

#Preview {
    AuthButton(title: "Login") {
        
    }
}
