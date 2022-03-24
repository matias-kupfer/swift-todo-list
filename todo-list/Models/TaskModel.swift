//
//  TaskModel.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import Foundation

struct TaskModel: Codable {
    let title: String
    var is_completed: Bool
}
