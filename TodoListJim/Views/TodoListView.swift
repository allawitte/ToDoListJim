//
//  ItemsView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI
import FirebaseFirestore

struct TodoListView: View {
    
    @StateObject var model: TodoListViewModel = TodoListViewModel()
    @StateObject var service = Service()
    private let userId: String
    init(userId: String) {
       self.userId = userId
    }
    
   
    var body: some View {
        NavigationView { 
            VStack {
                List(model.todos) { item in
                    ItemView(item: item)
                        .swipeActions {
                            Button {
                                model.delete(id: item.id)
                            } label: {
                                Text("Delete")
                            }
                        }
                        .tint(.red)

                }
                .listStyle(.plain)
            }
            .navigationTitle("Todo List")
            .toolbar {
                Button {
                    model.isNewRootItem = true
                    service.isPresented = true
                } label: {
                    Image(systemName: "plus")
                }

            }
            .sheet(isPresented: $service.isPresented) {
                NewItemView(newItemPresented: $service.isPresented)
            }
        }
        .onAppear() {
            model.todos = []
            model.getTodoList()
        }
      
    }
}

#Preview {
    TodoListView(userId: "wY0jU5sVZleeg49AbLSkXQ8c8Fj1")
    
}
