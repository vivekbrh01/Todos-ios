//
//  TodosView.swift
//  VivekScrumdinger
//
//  Created by Vivek Baruah on 18/09/25.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    var text: String
    var isComplete: Bool
    var isEditing: Bool = false
}

struct Checkbox: View {
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct TodosView: View {
    @State private var text: String = ""
    @State private var todos: [Item] = []
    @State private var isAllSelected: Bool = false
    @State private var activeTab: String = "All"

    private func addTodo() {
        guard !text.isEmpty else { return }
        todos.append(Item(text: text, isComplete: false))
        text = ""
    }

    private func removeTodoItem(id: UUID) {
        guard !id.uuidString.isEmpty else { return }
        if let index = todos.firstIndex(where: { $0.id == id }) {
            withAnimation {
                let _ = todos.remove(at: index)
            }
        }
    }
    var body: some View {
        VStack {
            Text("TODOS")
                .font(.title)
                .padding(4)
                .bold(true)
            HStack {
                Button {
                    for index in todos.indices {
                        todos[index].isComplete = !todos[index].isComplete
                    }
                    isAllSelected = !isAllSelected
                } label: {
                    Image(
                        systemName: isAllSelected
                            ? "checkmark.circle.fill" : "circle"
                    )
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(todos.isEmpty)

                TextField("Add items to the list...", text: $text)
                Button(action: addTodo) {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(text.isEmpty)
            }
            .padding(10)
            .border(.secondary)

            List {
                ForEach(
                    todos.filter {
                        activeTab == "All"
                            ? true
                            : activeTab == "Active"
                                ? !$0.isComplete : $0.isComplete
                    }
                ) { todo in
                    if let index = todos.firstIndex(where: { $0.id == todo.id })
                    {
                        HStack {
                            Checkbox(
                                isOn: $todos[index].isComplete
                            )
                            .disabled(todos[index].isEditing)
                            if todos[index].isEditing {
                                TextField(
                                    "Edit item",
                                    text: $todos[index].text
                                )
                            } else {
                                Button(action: {
                                    todos[index].isEditing = true
                                }) {
                                    Text(todos[index].text).strikethrough(
                                        todos[index].isComplete
                                    )
                                }
                                .foregroundColor(.primary)
                            }
                            Spacer()
                            if todos[index].isEditing {
                                Button(action: {
                                    todos[index].isEditing = false
                                }) {
                                    Text("Save")
                                }
                            } else {
                                Button(action: {
                                    removeTodoItem(id: todo.id)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .contentShape(Rectangle())
            }
            VStack {
                HStack {
                    let itemsLeft = todos.filter { !$0.isComplete }.count
                    Text("\(itemsLeft) item\(itemsLeft == 1 ? "" : "s") left")
                    Spacer()
                    HStack {
                        Button(action: {
                            activeTab = "All"
                        }) {
                            Text("All")
                        }
                        .foregroundStyle(
                            activeTab == "All" ? .blue : .secondary
                        )
                        Button(action: {
                            activeTab = "Active"
                        }) {
                            Text("Active")
                        }
                        .foregroundStyle(
                            activeTab == "Active" ? .blue : .secondary
                        )
                        Button(action: {
                            activeTab = "Completed"
                        }) {
                            Text("Completed")
                        }
                        .foregroundStyle(
                            activeTab == "Completed" ? .blue : .secondary
                        )
                    }
                }
                Button(action: {
                    activeTab = "All"
                    isAllSelected = false
                    todos.removeAll(where: { $0.isComplete })
                }) {
                    Text("Clear completed")
                }
                .padding([.top, .bottom], 10)
            }
            .buttonStyle(BorderlessButtonStyle())
            .contentShape(Rectangle())
            .foregroundColor(.primary)
            .padding(10)
        }
        .padding(10)
    }
}

#Preview {
    TodosView()
}
