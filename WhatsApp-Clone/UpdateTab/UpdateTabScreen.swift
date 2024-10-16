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
                Section {
                    recentUpdateStatusItemView()
                } header: {
                    Text("Recent Updates")
                }
                Section {
                    ChannelListView()
                } header: {
                    channelSectionHeader()
                }
            }
            
        }
        .navigationTitle("Updates")
        .searchable(text: $searText)
        .listStyle(.grouped)
    }
}


private struct statusSectionHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.dashed")
                .imageScale(.large)
                .foregroundStyle(.link)
            
            (
                Text("Use status to share photos, text and videos that dissappear in 24 hours. ")
                +
                Text("Status Privacy")
                    .foregroundStyle(.link).bold()
            )
            
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
            IconWithTransparentBG(imageName: "camera.fill")
            IconWithTransparentBG(imageName: "pencil")
        }
    }
}
private struct recentUpdateStatusItemView: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 55, height: 55)
            VStack(alignment: .leading) {
                Text("Shopnil Hasan")
                    .font(.callout)
                    .bold()
                Text("1hr ago")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct channelSectionHeader: View {
    var body: some View {
        HStack {
            Text("Channels")
                .textCase(nil)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.whatsAppBlack)
            Spacer()
            IconWithTransparentBG(imageName: "plus")
        }
    }
}
#Preview {
    UpdateTabScreen()
}
