//
//  ContentView.swift
//  MyToDos
//
//  Created by Khawla Zarrami on 14/04/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @State private var showCreate = false
    @Query(
        filter: #Predicate<ToDoItem> { !$0.isCompleted },
        sort: \.timestamp,
        order: .reverse
    )
    private var items: [ToDoItem]
    @State private var todoToEdit: ToDoItem?

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
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
                                .font(.largeTitle)
                                .bold()
                            
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.callout)
                        }
                        Spacer()
                        
                        Button {
                            withAnimation {
                                item.isCompleted.toggle()
                            }
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
            .navigationTitle("My To Do List")
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCreate.toggle()
                        } label: {
                            Label("Add Item", systemImage:  "plus")
                        }

                    }
                }
                .sheet(isPresented: $showCreate) {
                    NavigationStack {
                        CreateTodoView()
                    }
                    .presentationDetents([.medium])
                }
                .sheet(item: $todoToEdit) {
                    todoToEdit = nil
                } content: { item in
                    UpdateToDoView(item: item)
                }

        }
    }
}

#Preview {
    ContentView()
}
