//
//  TodoListItem.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation

struct TodoListItem: Codable, Identifiable {
    let id: String
    let title: String
    let dueDate: TimeInterval
    let createdDate: TimeInterval
    let level: Int
    let order: Int
    var isDone: Bool
    let parentId: String
    var indexing: [Int]
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
