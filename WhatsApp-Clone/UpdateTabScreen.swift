//
//  UpdateTabScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 29/6/24.
//

import SwiftUI

struct UpdateTabScreen: View {
    @State private var searText = ""
    var body: some View {
        NavigationStack {
            List {
                statusSectionHeader()
                    .listRowBackground(Color.clear)
                statusSection()
            }
            .navigationTitle("Updates")
            .searchable(text: $searText)
            .listStyle(.grouped)
        }
    }
}

private struct statusSectionHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.dashed")
                .imageScale(.large)
                .foregroundStyle(.link)
             
            VStack(alignment: .leading) {
                Text("Use status to share photos, text and videos that dissappear in 24 hours.")
                Text("Status Privacy")
                    .foregroundStyle(.link).bold()
            }
            
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.whatsAppWhite)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct statusSection: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text("My Status")
                    .font(.callout)
                    .bold()
                Text("Add to my status")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            statusSectionButton(imageName: "camera.fill")
            statusSectionButton(imageName: "pencil")
        }
    }
}

private func statusSectionButton(imageName: String) -> some View {
    Button {
        
    } label: {
        Image(systemName: imageName)
            .padding(10)
            .background(Color(.systemGray5))
            .bold()
            .clipShape(Circle())
    }
}
#Preview {
    UpdateTabScreen()
}
