//
//  ContentView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showCreate = false
    @Query private var items : [ToDo]
    @Environment(\.modelContext) var context
    @State private var todoToEdit: ToDo?
    @State private var showCreateCategory = false
    @State private var searchQuery: String = ""
    
    var filteredItems: [ToDo] {
        if searchQuery.isEmpty {
            return items
        }
        let filteredItems = items.compactMap { item in
            let titleContainQuery = item.title.range(of: searchQuery, options: .caseInsensitive) != nil
            let categoryTitleContainsQuery = item.category?.title.range(of: searchQuery, options: .caseInsensitive) != nil
            
            return (titleContainQuery || categoryTitleContainsQuery) ? item : nil
        }
        return filteredItems
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    ContentUnavailableView("To Do List Empty", systemImage: "checklist")
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    if item.isCritical {
                                        Image(systemName: "exclamationmark.3")
                                            .symbolVariant(.fill)
                                            .foregroundColor(.red)
                                            .font(.largeTitle)
                                            .bold()
                                        
                                    }
                                    Text(item.title)
                                        .bold()
                                        .font(.largeTitle)
                                    Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                        .font(.callout)
                                    
                                    if let category = item.category {
                                        Text(category.title)
                                            .foregroundStyle(Color.blue)
                                            .bold()
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                            .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    item.isCompleted.toggle()
                                } label: {
                                    Image(systemName: "checkmark")
                                        .symbolVariant(.circle.fill)
                                        .foregroundStyle(item.isCompleted ? .green : .gray)
                                        .font(.largeTitle)
                                }
                                .buttonStyle(.plain)
                                
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        context.delete(item)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                        .symbolVariant(.fill)
                                }
                                
                                Button {
                                    todoToEdit = item
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                    
                                }
                                .tint(.orange)
                                
                            }
                        }
                    }
                    
                }
            }
                    .navigationTitle("My Do List")
                    .searchable(text: $searchQuery ,placement: .navigationBarDrawer,
                                prompt: "Search for a to do or a category")
                    .overlay {
                        if filteredItems.isEmpty {
                            ContentUnavailableView.search
                        }
                    }
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button("New Category") {
                            showCreateCategory.toggle()
                        }
                                }
                                    
                }
            
                .safeAreaInset(edge: .bottom,
                                           alignment: .leading) {
                                Button(action: {
                                    showCreate.toggle()
                                }, label: {
                                    Label("New ToDo", systemImage: "plus")
                                        .bold()
                                        .font(.title2)
                                        .padding(8)
                                        .background(.gray.opacity(0.1),
                                                    in: Capsule())
                                        .padding(.leading)
                                        .symbolVariant(.circle.fill)
                                    
                                })
                                
                            }
            
            
            
            
                .sheet(isPresented: $showCreate) {
                    NavigationStack {
                        CreateToDoView()
                        
                    }
                    
                }
                .sheet(item: $todoToEdit) {
                    todoToEdit = nil
                } content: { item in
                    UpdateToDoView(item: item)
                }
                
                .sheet(isPresented: $showCreateCategory,
                                   content: {
                                NavigationStack {
                                    CreateCategoryView()
                                }
                            })

        }
    }
}

#Preview {
    ContentView()
}
