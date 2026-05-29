//
//  CreateCategoryView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 16/04/2026.
//

import SwiftUI
import SwiftData

@Model
class Category: Codable {
    @Attribute(.unique)
    var title: String
    
    
    var items: [ToDo]?
    
    init(title: String = "") {
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
    
    required init(from decoder:  Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
    }
}

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
    NavigationStack {
        CreateCategoryView()
    }
    
}
