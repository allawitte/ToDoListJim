//
//  User.swift
//  TodoListJim
//
//  Created by Alla on 30/05/2025.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String
    var email: String
    var joined: TimeInterval
}
