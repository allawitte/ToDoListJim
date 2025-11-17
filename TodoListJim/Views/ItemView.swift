//
//  SingleItemView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI

struct ItemView: View {
    var item: TodoListItem
    
    @StateObject var viewModel = ItemViewModel()
    @StateObject var model = TodoListViewModel()
    @StateObject var service = Service()
    
    var body: some View {
        HStack {
            //NavigationStack{
            
                HStack {
                    VStack(alignment: .leading){
                        HStack {
                            if item.isParent {
                                Image(systemName: item.isCollapsed ? "chevron.right" : "chevron.down")
                                    .font(.system(size: 10))
                                    .onTapGesture {
                                        model.toggleCollapse(id: item.id)
                                    }
                            }
                            Text(viewModel.getNumeration(item: item))
                                .font(.system(size: 12))
                            Text(item.title)
                                .font(.body)
                        }

                        Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(Color(.darkGray))
                       // Text("Order: \(item.order)  Level:\(item.level)")
                        Text("is collapsed: \(item.isCollapsed)")
                        
                    }
                    .padding(.leading, viewModel.getInset(item: item))
                    Spacer()
                    Image(systemName: "plus")
                        .onTapGesture {
                            model.isNewRootItem = false
                            service.isPresented = true
                            Service.item = item
                        }
                    
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(.teal)
                    .border(.gray)
                    .onTapGesture {
                        viewModel.toggleIsDone(item: item)
                    }
                }
                .sheet(isPresented: $service.isPresented) {
                    NewItemView(newItemPresented: $service.isPresented)
                }
          

        }
    } //
}

#Preview {
    ItemView(item: TodoListItem(id: "123", title: "Shopping", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, level: 1, order: 1, isDone: false, parentId: "123456", indexing: [1]))
}
