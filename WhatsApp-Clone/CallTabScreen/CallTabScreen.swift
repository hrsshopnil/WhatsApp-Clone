//
//  CallTabScreen.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 30/6/24.
//

import SwiftUI

struct CallTabScreen: View {
    @State private var searchText = ""
    @State private var callHistory = CallHistory.all
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Calls")
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Edit")
                }
                
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $callHistory) {
                        ForEach(CallHistory.allCases) {item in
                            Text(item.rawValue.capitalized)
                                .tag(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "phone.arrow.up.right")
                    }

                }
            }
        }
    }
    
    private enum CallHistory: String, CaseIterable, Identifiable {
        case all, missed
        
        var id: String {
            return rawValue
        }
    }
}

#Preview {
    CallTabScreen()
}
