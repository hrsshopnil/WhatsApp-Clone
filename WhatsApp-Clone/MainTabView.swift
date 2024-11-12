//
//  MainTabView.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 29/6/24.
//

import SwiftUI
import StreamVideoSwiftUI

struct MainTabView: View {
    
    private let loggedInUser: UserItem
    @StateObject var viewModel = CallViewModel()
    init(_ user: UserItem) {
        
        self.loggedInUser = user
        makeTabBarOpaque()
        
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
    
    var body: some View {
        TabView {
            ChatTabScreen()
                .tabItem {
                    Image(systemName: Tab.chats.icon)
                    Text(Tab.chats.title)
                }
            UpdateTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                    Text(Tab.updates.title)
                }
            CallTabScreen()
                .tabItem {
                    Image(systemName: Tab.calls.icon)
                    Text(Tab.calls.title)
                }
            CommunitiesTabScreen()
                .tabItem {
                    Image(systemName: Tab.communities.icon)
                    Text(Tab.communities.title)
                }
            SettingsTabScreen(loggedInUser)
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.title)
                }
        }
        .modifier(CallModifier(viewModel: viewModel))
        .environmentObject(viewModel)
    }
    
    private func makeTabBarOpaque(){
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension MainTabView {
    private func placeHolderItemView(_ title: String) -> some View {
        ScrollView {
            ForEach(0..<120) {_ in
                Text(title)
                    .font(.title)
            }
        }
    }
    
    
    private enum Tab: String {
        case chats, updates, calls, communities, settings
        
        fileprivate var title: String {
            return rawValue.uppercased()
        }
        
        fileprivate var icon: String {
            switch self {
                
            case .chats:
                "message"
            case .updates:
                "circle.dashed.inset.fill"
            case .calls:
                "phone"
            case .communities:
                "person.3"
            case .settings:
                "gear"
            }
        }
    }
}
#Preview {
    MainTabView(.placeHolder)
}
