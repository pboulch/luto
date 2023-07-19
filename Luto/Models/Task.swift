//
//  Task.swift
//  Luto
//
//  Created by Pierre Boulc'h on 13/07/2023.
//

import Foundation

class Task {
    let id: Int64
    var title: String
    var body: String
    
    init(title: String, body: String) {
        self.id = 0
        self.title = title
        self.body = body
    }
    
    init(id: Int64, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
}
