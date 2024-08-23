//
//  SetUpGroupView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 14/7/24.
//

import SwiftUI

struct SetUpGroupView: View {
    @State private var groupName = ""
    @ObservedObject var viewModel: ChatPartnerPickerViewModel
    var onCreate: (_ newChatRoom: ChannelItem) -> Void
    var body: some View {
        List {
            HStack {
                Image(systemName: "camera.fill")
                    .imageScale(.large)
                    .foregroundStyle(Color.primary)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(Circle())
                
                TextField("Group Name (optional)", text: $groupName)
            }
            Section {
                Text("Disappearing Messages")
                Text("Group Permission")
            }
            Section {
                SelectedPartnerView(users: viewModel.selectedChatPartners) { user in
                    viewModel.handleItemSelection(user)
                }
            } header: {
                let count = viewModel.selectedChatPartners.count
                let maxCount = ChannelConstants.maxGroupParticipants
                Text("Participants: \(count) of \(maxCount)")
            }
            .listRowBackground(Color.clear)
        }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Group")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        if viewModel.isDirectchannel {
                            guard let chatPartner = viewModel.selectedChatPartners.first else { return }
                            viewModel.createDirectChannel(chatPartner, completion: onCreate)
                        } else {
                            viewModel.createGroupChannel(groupName, completion: onCreate)
                        }
                    }
                    .disabled(viewModel.disableButton)
                }
            }
        
    }
}

#Preview {
    NavigationStack {
        SetUpGroupView(viewModel: ChatPartnerPickerViewModel()) {_ in
            
        }
    }
}
