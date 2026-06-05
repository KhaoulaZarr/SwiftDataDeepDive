//
//  CreateCategoryView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 16/04/2026.
//

import SwiftUI
import SwiftData

extension Category {
    static var defaults:[Category] {
        [
            .init(title: "🌷Study"),
            .init(title: "🌾 Routine"),
            .init(title: "😸 Family")
        ]
    }
}

struct CreateCategoryView: View {
   @State private var title = ""
   @Environment(\.modelContext) var modalContext
   @Query private var categories: [Category]
   @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Category Title") {
                TextField("Enter Title Here", text: $title)
                Button("Add Category") {
                    withAnimation {
                        let category = Category(title: title)
                        modalContext.insert(category)
                        category.items = []
                        title = ""
                    }
                }
                .disabled(title.isEmpty)
            }
            
            Section("Categories") {
                if categories.isEmpty {
                    
                    ContentUnavailableView("No Categories", systemImage: "tray")
                } else {
                    ForEach(categories) { category in
                        Text(category.title)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modalContext.delete(category)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }

                            }
                    }
                }
                
            }
        }
        .navigationTitle("Add Category")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SwiftDataViewer(preview: PreviewContainer([ToDo.self])) {
        NavigationStack {
            CreateCategoryView()
        }
    }
}
