//
//  LoginView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    var body: some View {
        VStack {
            //header
            HeaderView(title: "Todo List", subtitle: "Get your tasks done!", angle: 15, background: .pink)
            //login
            VStack {
                VStack {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    TextField("Email Address", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 15)
                    SecureField("Password", text: $viewModel.password)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding(.horizontal, 15)
                    TLButton(title: "Log In", backGround: .blue, action: viewModel.login)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(20)
                .frame(width: UIScreen.main.bounds.width - 40)
            }
            .padding(20)
            .textFieldStyle(.roundedBorder)
            .offset(y: -50)
            //create account
            VStack {
                TLButton(title: "JIm Login", backGround: .red, action: viewModel.jimLogin)
                    .frame(width: 300, height: 50)
                
                Text("New around here? ")
                NavigationLink("Create an account!", destination: RegisterView())
                
            }
            .padding(.bottom, 50)
            Spacer()
        }
        //.background(Color.white)
    }
}

#Preview {
    LoginView()
}
