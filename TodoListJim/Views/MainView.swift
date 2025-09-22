//
//  ContentView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//


import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    var body: some View {
        NavigationStack {
            if /*viewModel.letGo()*/ viewModel.isSignedIn, !viewModel.currentUserID.isEmpty {
                TabView {
                    Tab("Home", systemImage: "house") {
                        TodoListView(userId: viewModel.currentUserID)
                    }
                    Tab("Profile", systemImage: "person.circle") {
                        ProfileView()
                    }
                }
            } else {
                LoginView()
            }
        }
      
    }
}

#Preview {
    MainView()
}
