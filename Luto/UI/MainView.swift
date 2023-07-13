//
//  ContentView.swift
//  Luto
//
//  Created by Pierre Boulc'h on 04/07/2023.
//

import SwiftUI
import AppKit

struct MainView: View {
    
    @State var taskTitle = ""
    @State var taskDescription = ""
    @State var listTask: [String] = []
    
    @State var showAdditionnalFields = false
    @FocusState private var titleFieldInFocus: Bool
    @FocusState private var descriptionFieldInFocus: Bool

    
    var body: some View {
        VStack {
            Text("Mes tâches")
            LazyVStack(alignment: .leading) {
                ForEach(Array(listTask.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Text("\(task)")
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8))
                        Spacer()
                        Button(action: {
                            removeTask(index: index)
                        }, label: {
                            Image(systemName: "trash")
                        }).buttonStyle(PlainButtonStyle()).padding(12)
                            .foregroundColor(.accentColor)
                    }.border(width: 5, edges: [.leading], color: .accentColor)
                }
            }
            Spacer()
            HStack {
                TextField("Titre de la tâche ...", text: $taskTitle).focused($titleFieldInFocus).onChange(of: titleFieldInFocus) { isFocused in
                    if !isFocused {
                        withAnimation {
                            showAdditionnalFields = true
                        }
                    }
                }.onSubmit {
                    addTask()
                }
                Button(action: {
                    addTask()
                }, label: {
                    Image(systemName: "plus")
                }).buttonStyle(PlainButtonStyle()).padding(12)
                    .background(Color.accentColor)
                    .foregroundColor(.black)
                    .cornerRadius(24)
            }.textFieldStyle(OvalTextFieldStyle())
            if showAdditionnalFields {
                TextField("Description", text: $taskDescription).focused($descriptionFieldInFocus)
            }
        }
        .padding()
        .frame(width: 500, height: 500)
    }
    
    func addTask() {
        if !taskTitle.isEmpty {
            withAnimation {
                listTask.append(taskTitle)
            }
            taskTitle = ""
        }
    }
    
    func removeTask(index: Int) {
        _ = withAnimation {
            listTask.remove(at: index)
        }
    }
    
    init(taskTitle: String = "", taskDescription: String = "", listTask: [String]) {
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.listTask = listTask
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(taskTitle: "", taskDescription: "", listTask: [])
    }
}
