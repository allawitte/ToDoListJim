//
//  LoginViewModel.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation

import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    init() {}
    
    func login() {
        guard validate() else {return}
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func jimLogin() {
        Auth.auth().signIn(withEmail: "jim@gmail.com", password: "1234567")
    }
    
    
    func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Email and password required"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please input valid email"
            return false
        }
        return true
    }
}
