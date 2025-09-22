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
                            Text(viewModel.getNumeration(item: item))
                            Text(item.title)
                                .font(.body)
                        }
                        Text("\(Date(timeIntervalSince1970: item.dueDate).formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundStyle(Color(.darkGray))
                        Text("Order: \(item.order)  Level:\(item.level)")
                    }
                    .padding(.leading, viewModel.getInset(item: item))
                    Spacer()
                    Button {
                        model.isNewRootItem = false
                        service.isPresented = true
                        Service.item = item
                    } label: {
                        Image(systemName: "plus")
                    }
                    

                   
                   
                    
                    Button {
                        viewModel.toggleIsDone(item: item)
                    } label: {
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(.teal)
                    }
                    .border(.gray)
                }.sheet(isPresented: $service.isPresented) {
                    NewItemView(newItemPresented: $service.isPresented)
            }

        }
    } //
}

#Preview {
    ItemView(item: TodoListItem(id: "123", title: "Shopping", dueDate: Date().timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, level: 1, order: 1, isDone: false, parentId: "123456", indexing: [1]))
}
