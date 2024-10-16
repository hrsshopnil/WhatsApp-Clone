//
//  WhatsApp_CloneApp.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 28/6/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WhatsApp_CloneApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var viewModel = GetCurrentUser()
  var body: some Scene {
    WindowGroup {
        RootView()
    }
  }
}
