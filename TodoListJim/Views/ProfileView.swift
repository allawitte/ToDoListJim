//
//  ProfileView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var model = ProfileViewModel()
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                //Avatar
                if let user = model.user {
                    profile(user: user)
                    
                }
                else {
                Text("Loading user...")
            }
                
                //Sign Out
                TLButton(title: "Sign Out", backGround: .yellow) {
                    model.logout()
                }
                .frame(width: 300, height: 70)
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            model.fetchUser()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.blue)
            .frame(width: 125, height: 125)
            .padding()
        //Info
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Name:")
                    .bold()
                Text(user.name)
            }
            HStack {
                Text("Email:")
                    .bold()
                Text(user.email)
            }
            HStack {
                Text("Member since:")
                    .bold()
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
