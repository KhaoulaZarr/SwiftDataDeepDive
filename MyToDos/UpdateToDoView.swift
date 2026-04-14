//
//  UpdateToDoView.swift
//  MyToDos
//
//  Created by Khawla Zarrami on 14/04/2026.
//

import SwiftUI

struct UpdateToDoView: View {
    @Bindable var item: ToDoItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            TextField("Name", text: $item.title)
            DatePicker("Choose a date ?", selection: $item.timestamp)
            Toggle("Important?", isOn: $item.isCritical)
            
            Button("Update") {
                dismiss()
            }
        }
        .navigationTitle("Update ToDo")
    }
}

#Preview {
    UpdateToDoView(item: .init())
}
