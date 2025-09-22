//
//  MainViewModel.swift
//  TodoListJim
//
//  Created by Alla on 31/05/2025.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var currentUserID: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener {[weak self]  _, user in
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? ""
            }
            
            
            
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func letGo() -> Bool {
        
        print("Check if you can come in \(!self.currentUserID.isEmpty || self.isSignedIn)")
        return !self.currentUserID.isEmpty || self.isSignedIn
    }
}
