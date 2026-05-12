//
//  CreateToDoView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateToDoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var item = ToDo()
    @Environment(\.modelContext) var context
    @Query private var categories:[Category]
    @State var  selectedCategory: Category?
    
    @State var selectedPhoto: PhotosPickerItem?
    
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
                if let imageData = item.image , let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                }
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()
                ) {
                   Label("Add Photos", systemImage: "photo")
                }
                
                if item.image != nil {
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            item.image = nil
                        }
                    }label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
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
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
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
