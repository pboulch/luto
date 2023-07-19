//
//  TaskViewModel.swift
//  Luto
//
//  Created by Pierre Boulc'h on 18/07/2023.
//

import Foundation

class TaskViewModel: ObservableObject {

    @Published var allTask: [Task] = []
    
    init() {
        getTaskList()
    }
    
    func addTask(name: String, body: String) {
        let id = TaskDataStore.shared.insert(name: name, description: body)
        if id != 0 {
            getTaskList()
        }
    }
    
    func getTaskList() {
        allTask = TaskDataStore.shared.getAllTasks()
    }
    
    func deleteTask(at indexSet: IndexSet) {
        let id = indexSet.map { self.allTask[$0].id }.first
        if let id = id {
            let delete = TaskDataStore.shared.delete(id: id)
            if delete {
                getTaskList()
            }
        }
    }

}
