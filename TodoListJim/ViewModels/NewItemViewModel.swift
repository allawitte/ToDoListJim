//
//  NewItemViewModel.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class NewItemViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dueDate = Date()
    var level: Int = 1
    var order: Int = 0
    var indexing: [Int] = []
    var parentId: String = ""
    @Published var showAlert: Bool = false
    @Published var mainModel = TodoListViewModel()
    //@Published var service = Service()

//    init() {
//        print("Service Item \(Service.item)")
//    }
    
    func save() {
        
        guard canSave else {return}
        
        //get current user Id
        guard let uid = Auth.auth().currentUser?.uid else {return}
        //setting order and level

        if let item = Service.item {
            level = item.level + 1
            parentId = item.id
            order = item.order
            indexing = item.indexing
            let nextOrder: Int = mainModel.getNextOrder(parentId: parentId)
            indexing.append(nextOrder)
            if let index = Service.allItems.firstIndex(where: {$0.id == parentId}) {
                var parentItem = Service.allItems[index]
                if !parentItem.isParent {
                    parentItem.isParent = true
                    TodoListViewModel.saveOneItem(item: parentItem)
                }
            }
            print("subitem")
        } else {
            level = 1
            order = mainModel.getParentsOrder() + 1  //Service.order + 1
            indexing = [order]
            print("new item")
        }
        //creatye model
        let newId = UUID().uuidString
        let newItem = TodoListItem(id: newId,
                                   title: title,
                                   dueDate: dueDate.timeIntervalSince1970,
                                   createdDate: Date().timeIntervalSince1970,
                                   level: level,
                                   order: order,
                                   isDone: false,
                                   parentId: parentId,
                                   indexing: indexing)
        
        //save model
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(newId)
            .setData(newItem.asDictionary())
            
        Service.item = nil
        mainModel.addAndSort(item: newItem)
        
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }
        
        return true
    }
}
