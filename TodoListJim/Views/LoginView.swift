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
            
            Form {
                VStack {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(Color.red)
                    }
                    TextField("Email Address", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                    SecureField("Password", text: $viewModel.password)
                        .multilineTextAlignment(.center)
                    TLButton(title: "Log In", backGround: .blue, action: viewModel.login)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .formStyle(.automatic)
            .textFieldStyle(.roundedBorder)
          
            .offset(y: -50)
            
            
            
            //create account
            VStack {
                Text("New around here? ")
                NavigationLink("Create an account!", destination: RegisterView())
                
            }
            .padding(.bottom, 50)
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
