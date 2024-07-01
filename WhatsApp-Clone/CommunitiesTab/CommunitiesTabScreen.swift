//
//  SwiftUIView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 1/7/24.
//

import SwiftUI

struct CommunitiesTabScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading,  spacing: 10) {
                    Image(.communities)
                    Group {
                        Text("Stay connected with communities")
                            .font(.title2)
                        Text("Communities bring members together in topic-based groups. Any communities you are added to will appear here")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    
                    Button("See example communities >") { }
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button {
                        
                    } label: {
                        Label("New Community", systemImage: "plus")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .padding(8)
                            .bold()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .foregroundStyle(.blue)
                            )
                        
                    }
                    .padding(.top, 8)
                    .padding(.horizontal)
                }
                .padding()
                .navigationTitle("Communities")
            }
        }
    }
}

#Preview {
    CommunitiesTabScreen()
}
