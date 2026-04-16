//
//  UpdateToDoView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData

struct UpdateToDoView: View {
    @Bindable var item: ToDo
    @Environment(\.dismiss) var dismiss
    @State var selectedCategory: Category?
    @Query private var categories: [Category]
    
    var body: some View {
        List {
            Section("To Do Title") {
                TextField("Name", text: $item.title)
            }
            Section("General") {
                DatePicker("Choose a date ?", selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }
            Section("Select A Category") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "tray")
                } else {
                    Picker("", selection: $selectedCategory) {
                        ForEach(categories) { category in
                            Text(category.title)
                                .tag(category as Category?)
                        }
                        Text("None")
                            .tag(nil as Category?)
                    }
                    .labelsHidden()
                    .pickerStyle(.inline)
                }
                
                
            }
            
            Section {
                Button("Update") {
                    item.category = selectedCategory
                    dismiss()
                }
            }
            
        }
        .navigationTitle("Update ToDo")
        .onAppear {
            selectedCategory = item.category
        }
    }
}

#Preview {
    UpdateToDoView(item: ToDo())
        .modelContainer(for: ToDo.self)
}
