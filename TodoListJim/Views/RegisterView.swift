//
//  RegisterView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = RegisterViewModel()
    var body: some View {
        NavigationStack {
            HeaderView(title: "Register", subtitle: "Start to organize", angle: -15, background: .orange)
            
            Form {
                VStack {
                    TextField("Full mane", text: $viewModel.name)
                    TextField("Email Address", text: $viewModel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $viewModel.password)
                    TLButton(title: "Create an account", backGround: .green) {
                        viewModel.register()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .formStyle(.automatic)
            .textFieldStyle(.roundedBorder)
            .offset(y: -50)
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
