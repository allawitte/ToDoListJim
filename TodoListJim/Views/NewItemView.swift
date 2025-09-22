//
//  NewItemView.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import SwiftUI


struct NewItemView: View {
    @StateObject var viewModel = NewItemViewModel()
    @StateObject var model = TodoListViewModel()
    @Binding var newItemPresented: Bool
    @Environment(\.dismiss) private var dismiss
    

    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 100)
            
            Form {
                VStack {
                    TextField("Title", text: $viewModel.title)
                    DatePicker("Due Date", selection: $viewModel.dueDate)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    TLButton(title: "Save", backGround: .cyan) {
                        print("can save: \(viewModel.canSave)")
                        if viewModel.canSave {
                            viewModel.save()
                            dismiss()
                            
                            
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .padding()
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text("Please, fill out all the fileds and select date today or later"))
                }
            }
        }
        .onDisappear() {
            //model.addAndSort(item: <#T##TodoListItem#>)
            
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        //
    }))
}
