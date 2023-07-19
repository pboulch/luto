//
//  TaskDataStore.swift
//  Luto
//
//  Created by Pierre Boulc'h on 17/07/2023.
//

import Foundation
import SQLite

class TaskDataStore {

    static let DIR_TASK_DB = "TaskDB"
    static let STORE_NAME = "task.sqlite3"

    private let tasks = Table("tasks")

    private let id = Expression<Int64>("id")
    private let title = Expression<String>("title")
    private let body = Expression<String>("body")

    static let shared = TaskDataStore()

    private var db: Connection? = nil

    private init() {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_TASK_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                createTable()
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }

    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(tasks.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(title)
                table.column(body)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }

    func insert(name: String, description: String) -> Int64? {
        guard let database = db else { return nil }

        let insert = tasks.insert(self.title <- name,
                                  self.body <- description)

        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }

    func getAllTasks() -> [Task] {
        var tasks: [Task] = []
        guard let database = db else { return [] }

        do {
            for task in try database.prepare(self.tasks) {
                tasks.append(Task(id: task[id], title: task[title], body: task[body]))
            }
        } catch {
            print(error)
        }
        return tasks
    }


    func findTask(taskId: Int64) -> Task? {
        var task: Task = Task(id: taskId, title: "", body: "")
        guard let database = db else { return nil }

        let filter = self.tasks.filter(id == taskId)
        do {
            for t in try database.prepare(filter) {
                task.title = t[title]
                task.body = t[body]
            }
        } catch {
            print(error)
        }
        return task
    }

    func update(id: Int64, name: String, date: Date = Date(), status: Bool = false) -> Bool {
        guard let database = db else { return false }

        let task = tasks.filter(self.id == id)
        do {
            let update = task.update([
                title <- title,
                self.body <- body,
            ])
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }

    func delete(id: Int64) -> Bool {
        guard let database = db else {
            return false
        }
        do {
            let filter = tasks.filter(self.id == id)
            try database.run(filter.delete())
            return true
        } catch {
            print(error)
            return false
        }
    }
}
