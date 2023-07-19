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
    
    @ObservedObject var viewModel: TaskViewModel
    
    @State var taskTitle = ""
    @State var taskDescription = ""
    
    @State var showAdditionnalFields = false
    
    @FocusState private var focusState: FocusStateField?
    
    var body: some View {
        VStack {
            Text("Mes tâches")
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(viewModel.allTask.enumerated()), id: \.offset) { index, task in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(task.title)").font(.system(size: 16))
                                if !task.body.isEmpty {
                                    Text("\(task.body)")
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
                }.onAppear {
                    focusState = .titleField
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
            } else {
                Button(action: {
                    showAdditionnalFields = true
                }, label: {
                    Image("arrow-down").tint(Color.white)
                }).buttonStyle(PlainButtonStyle())
                
            }
        }
        .padding()
        .frame(width: 500, height: 500)
    }
    
    func addTask() {
        if !taskTitle.isEmpty {
            withAnimation {
                viewModel.addTask(name: taskTitle, body: taskDescription)
            }
            taskTitle = ""
            taskDescription = ""
            showAdditionnalFields = false
            focusState = .titleField
        }
    }
    
    func removeTask(index: Int) {
        withAnimation {
            viewModel.deleteTask(at: IndexSet([index]))
        }
    }
}
