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
    var nest: [String] = []
    init() {
        todos = Service.allItems
    }

    
    
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
                    let isParent = doc["isParent"] as? Bool ?? false
                    let isCollapsed = doc["isCollapsed"] as? Bool ?? false
                    let indexing = doc["indexing"] as? [Int] ?? []
                    let isHidden = doc["isHidden"] as? Bool ?? false
                    items.append(TodoListItem(id: doc.documentID, title: title, dueDate: dueDate, createdDate: createdDate, level: level, order: order, isDone: isDone, parentId: parentId, indexing: indexing, isCollapsed: isCollapsed,  isParent: isParent, isHidden: isHidden))
                }
                items.sort { ($0.indexing.map { String($0) }.joined(separator: ".")) < ($1.indexing.map { String($0) }.joined(separator: "."))}

                sortItems(items: &items)
                
                                 
                self.todos = items
                Service.allItems = items
                self.order = items.last?.order ?? 1
                //openAll()
            })
        
    }
    
    func getParentsOrder() -> Int {
        let parentsOnly = Service.allItems.filter { $0.parentId == ""}
        print("Parents Only \(parentsOnly)")
        return parentsOnly.count
    }
    
    func delete(id: String) {
        renumber(id: id)
        
        nest.append(id)
        getNest(id: id)
        setIsParent(id: id)
        for item in nest {
            let db = Firestore.firestore()
            guard let userId = Auth.auth().currentUser?.uid else {return}
            db.collection("users")
                .document(userId)
                .collection("todos")
                .document(item)
                .delete()
            getTodoList()
        }
    }
    
    func getNest(id: String) {
        
        let subList = todos.filter { $0.parentId == id}
        for element in subList {
            nest.append(element.id)
            getNest(id: element.id)
        }

    }
    
    func renumber(id: String) {
        var level = 0
        var j = 0
        guard var index = todos.firstIndex(where: {$0.id == id}) else {return}
        var startIndex = index
        
        while todos[index].parentId != "" {
            j += 1
            if let i = todos.firstIndex(where: {$0.id == todos[index].parentId}) {
                index = i
                level += 1
            } else {
                break
            }
        }
        
        for i in startIndex..<todos.count {
            if todos[i].indexing.count == level + 1 && i > startIndex {
                startIndex = i
                break
            }
        }
        
        for i in startIndex..<todos.count {
            if todos[i].indexing.count < level + 1 {
                break
            }
            print(todos[i].indexing)
            todos[i].indexing[level] -= 1
            
        }
        print("level \(level)")
        print("Start Index \(startIndex)  todo count \(todos.count)")
    }
    
    func addAndSort(item: TodoListItem) {
        todos.append(item)
        sortItems(items: &todos)
    }
    
    func sortItems(items: inout [TodoListItem]) {
        
        if items.count > 1 {
            
            for z in 0..<items.count - 1 {
                for i in 0..<items.count - 1 - z {
                    let a = items[i]
                    let b = items[i + 1]
                    let lenghts = min(a.indexing.count, b.indexing.count)
                    
                    for j in 0..<lenghts {
                        
                        if a.indexing[j] > b.indexing[j] {
                                
                                items[i] = b
                                items[i + 1] = a
                                break
                          
                            
                        }
                        else if a.indexing[j] == b.indexing[j] && j == lenghts - 1 {
                            if a.indexing.count > b.indexing.count {
                                items[i] = b
                                items[i + 1] = a
                                break
                            }
                        }
                        else {
                            break
                        }
                        
                       
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
    
    func setIsParent() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        for todo in todos {
            var item = todo
            if todos.firstIndex(where: {$0.parentId == todo.id}) != nil {
                
                item.isParent = true
               
            } else {
                item.isParent = false
            }
            db.collection("users")
                .document(uid)
                .collection("todos")
                .document(item.id)
                .setData(item.asDictionary())
        }
    }
    
    func setIsParent(id: String) {
        var count = 0
        
        guard let idIndex = todos.firstIndex(where: {$0.id == id}) else {return}
        let currentItem = todos[idIndex]
        let parentId = currentItem.parentId
        if let index = todos.firstIndex(where: {$0.id == parentId}) {
            var parentItem = todos[index]
            for todo in todos {
                if todo.parentId == parentId && todo.id != id {
                    count += 1
                }
            }
            if count == 0 {
                parentItem.isParent = false
                TodoListViewModel.saveOneItem(item: parentItem)
            }
        }
        
        
    }
    
    static func saveOneItem(item: TodoListItem) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(item.id)
            .setData(item.asDictionary())
    }
    
     func toggleCollapse(id: String) {
        if let index = todos.firstIndex(where: {$0.id == id}) {
            var item = todos[index]
            print("is collapsed \(item.isCollapsed)")
            
            let parentId = item.parentId
            for i in index + 1 ..< todos.count {
                if todos[i].parentId == parentId || todos[i].parentId == "" {
                    print("break \(i)")
                    break}
                else {
                    todos[i].isHidden = item.isCollapsed ? true : false
                    print("is hidden \(todos[i].isHidden)")
                    TodoListViewModel.saveOneItem(item: todos[i])
                }
            }
            item.isCollapsed.toggle()
            TodoListViewModel.saveOneItem(item: item)
            getTodoList()
        }
    }

    
    func openAll() {
        for i in 0 ..< todos.count {
            todos[i].isHidden = false
            TodoListViewModel.saveOneItem(item: todos[i])
        }
    }
}
    
    
    
   



