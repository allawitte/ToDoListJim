//
//  TodoListJimApp.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct TodoListJimApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

//    init() {
//        FirebaseApp.configure()
//    }

      var body: some Scene {
        WindowGroup {
          //NavigationView {
            MainView()
          //}
        }
      }
}
