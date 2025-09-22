//
//  ItemViewModel.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ItemViewModel: ObservableObject {
    var showNewItemView: Bool = false
    
    init() {}
    
    func toggleIsDone(item: TodoListItem) {
        var newItem = item
        newItem.setDone(!item.isDone)
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(item.id)
            .setData(newItem.asDictionary())
    }
    func getLevel(item: TodoListItem) -> String {
        return "\(item.order).\(item.level)"
    }
    
    func getInset(item: TodoListItem) -> CGFloat {
        return CGFloat(item.level * 10)
    }
    
    func getNumeration(item: TodoListItem) -> String {
        return item.indexing.map { String($0) }.joined(separator: ".")
    }
    
}
