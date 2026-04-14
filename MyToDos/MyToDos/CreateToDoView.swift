//
//  CreateToDoView.swift
//  MyToDos
//
//  Created by Khawla Zarrami on 14/04/2026.
//

import SwiftUI
import SwiftData

struct CreateTodoView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var item = ToDoItem()
    
    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date",
                       selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            Button("Create") {
                withAnimation {
                    context.insert(item)
                }
                dismiss()
            }
        }
        .navigationTitle("Create ToDo")
    }
}
#Preview {
    CreateTodoView()
        .modelContainer(for: ToDoItem.self)
}
