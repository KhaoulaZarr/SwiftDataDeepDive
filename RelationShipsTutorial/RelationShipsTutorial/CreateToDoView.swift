//
//  CreateToDoView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var item = ToDo()
    @Environment(\.modelContext) var context
    @Query private var categories:[Category]
    @State var  selectedCategory: Category?
    
    var body: some View {
        List {
            Section("To do title") {
                TextField("Name", text: $item.title)
            }
            
            Section("General") {
                DatePicker("Choose a date",
                           selection: $item.timestamp)
                Toggle("Important?", isOn: $item.isCritical)
            }
            
            Section("Select a Category") {
                if categories.isEmpty {
                    ContentUnavailableView("No Categories", systemImage: "tray")
                }else {
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
                Button("Create") {
                    save()
                    dismiss()
                }
            }
           
        }
        .navigationTitle("Create ToDo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
    }
}

private extension CreateToDoView {
    
    func save() {
        context.insert(item)
        item.category = selectedCategory
        selectedCategory?.items?.append(item)
    }
}

#Preview {
    CreateToDoView()
        .modelContainer(for: ToDo.self)
}
