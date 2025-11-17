//
//  Service.swift
//  TodoListJim
//
//  Created by Alla on 22/08/2025.
//

import Foundation
import SwiftUI

class Service: ObservableObject {
    
    @Published var isPresented: Bool = false
    static var item: TodoListItem? = nil
    static var allItems: [TodoListItem] = []
    static var order: Int = 1
}

