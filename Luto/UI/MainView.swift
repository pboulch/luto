//
//  ContentView.swift
//  Luto
//
//  Created by Pierre Boulc'h on 04/07/2023.
//

import SwiftUI
import AppKit

struct MainView: View {
    
    private enum FocusStateField: Hashable{
        case titleField
        case descriptionField
    }
    
    @State var taskTitle = ""
    @State var taskDescription = ""
    @State var listTask: [Task] = []
    
    @State var showAdditionnalFields = false
    
    @FocusState private var focusState: FocusStateField?
    
    var body: some View {
        VStack {
            Text("Mes tâches")
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(listTask.enumerated()), id: \.offset) { index, task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(task.title)").font(.system(size: 16))
                                if !task.description.isEmpty {
                                    Text("\(task.description)")
                                }
                            }
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
            }
            Spacer()
            Divider()
            HStack {
                TextField("Titre de la tâche ...", text: $taskTitle).focused($focusState, equals: .titleField).onChange(of: focusState) { newFocusState in
                    if newFocusState != .titleField {
                        withAnimation {
                            showAdditionnalFields = true
                            focusState = .descriptionField
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
                TextField("Description ...", text: $taskDescription).focused($focusState, equals: .descriptionField).textFieldStyle(OvalTextFieldStyle()).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).onSubmit {
                    addTask()
                }
            }
        }
        .padding()
        .frame(width: 500, height: 500)
    }
    
    func addTask() {
        if !taskTitle.isEmpty {
            withAnimation {
                listTask.append(Task(title: taskTitle, description: taskDescription))
            }
            taskTitle = ""
            taskDescription = ""
            showAdditionnalFields = false
            focusState = .titleField
        }
    }
    
    func removeTask(index: Int) {
        _ = withAnimation {
            listTask.remove(at: index)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
