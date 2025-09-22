//
//  TodoListViewModel.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TodoListViewModel: ObservableObject {
    @Published var showNewItemView: Bool = false
    @Published var isNewRootItem: Bool = false
    @Published var todos: [TodoListItem] = []
    var level: Int = 1
    @Published var order: Int = 1
    
    
    
    
    func getTodoList() {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("todos")
            .order(by: "order")
            .order(by: "level")
            .addSnapshotListener({[weak self] snapshot, err in
                guard let self = self else {return}
                guard err == nil else {
                    print(err!)
                    return
                }
                guard let docs = snapshot?.documents else {return}
                var items = [TodoListItem]()
                docs.forEach { doc in
                    let title = doc["title"] as? String ?? ""
                    let dueDate = doc["dueDate"] as? TimeInterval ?? 0
                    let createdDate = doc["createdDate"] as? TimeInterval ?? 0
                    let isDone = doc["isDone"] as? Bool ?? false
                    let level = doc["level"] as? Int ?? 0
                    let order = doc["order"] as? Int ?? 0
                    let parentId = doc["parentId"] as? String ?? ""
                    let indexing = doc["indexing"] as? [Int] ?? []
                    items.append(TodoListItem(id: doc.documentID, title: title, dueDate: dueDate, createdDate: createdDate, level: level, order: order, isDone: isDone, parentId: parentId, indexing: indexing))
                }
                items.sort { ($0.indexing.map { String($0) }.joined(separator: ".")) < ($1.indexing.map { String($0) }.joined(separator: "."))}

                sortItems(items: &items)
                
                                 
                self.todos = items
                Service.allItems = items
                self.order = items.last?.order ?? 1
                print("order is \(self.order)")
                print("Items amount: \(items.count)")
                
            })
        //return items
    }
    
    func delete(id: String) {
        let db = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else {return}
        db.collection("users")
            .document(userId)
            .collection("todos")
            .document(id)
            .delete()
        getTodoList()
    }
    
    func addAndSort(item: TodoListItem) {
        todos.append(item)
        sortItems(items: &todos)
    }
    
    func sortItems(items: inout [TodoListItem]) {
        if items.count > 1 {
            var trigger = false
            for z in 0..<items.count - 1 {
                for i in 0..<items.count - 1 - z {
                    let a = items[i]
                    let b = items[i + 1]
                    var lenghts = a.indexing.count
                    if b.indexing.count < lenghts {
                        lenghts = b.indexing.count
                    }
                    
                    for j in 0..<lenghts {
                        
                        if a.indexing[j] > b.indexing[j] {
                            if !trigger {
                                items[i] = b
                                items[i + 1] = a
                            }
                            trigger = true
                            continue
                        }
                        if a.indexing[j] == b.indexing[j] && j == lenghts - 1 {
                            if a.indexing.count > b.indexing.count {
                                items[i] = b
                                items[i + 1] = a
                                continue
                            }
                        }
                        trigger = false
                    }
                }
            }
        }
       }
    
    
    func getNextOrder(parentId: String) -> Int {
        var itemsInNest = [TodoListItem]()
        print("Todos count\(Service.allItems.count)")
        for item in Service.allItems {
            print("search: \(item.parentId)")
            if item.parentId == parentId {
                itemsInNest.append(item)
                
            }
        }
        return itemsInNest.count + 1
    }
}
    
    
    
   



