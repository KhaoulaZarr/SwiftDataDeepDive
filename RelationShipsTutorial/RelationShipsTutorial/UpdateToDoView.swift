//
//  UpdateToDoView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateToDoView: View {
    @Bindable var item: ToDo
    @Environment(\.dismiss) var dismiss
    @State var selectedCategory: Category?
    @Query private var categories: [Category]
    
    @State var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        List {
            Section("To Do Title") {
                TextField("Name", text: $item.title)
            }
            Section("General") {
                DatePicker("Choose a date ?", selection: $item.dueDate)
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
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
            }
        }
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer([ToDo.self])) {
        NavigationStack {
            UpdateToDoView(item: ToDo.dummy)
        }
    }

    
}
