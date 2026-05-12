//
//  ContentView.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData
import SwiftUIImageViewer

enum SortOption: String, CaseIterable {
    case title
    case date
    case category
}

extension SortOption {
    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
        case .category:
            "folder"
        }
    }
}

struct ContentView: View {
    @State private var showCreate = false
    @Query private var items : [ToDo]
    @Environment(\.modelContext) var context
    @State private var todoToEdit: ToDo?
    @State private var showCreateCategory = false
    @State private var searchQuery: String = ""
    @State private var selectedSortOption = SortOption.allCases.first!
    @State private var isImageViewerPresented = false
    
    var filteredItems: [ToDo] {
        if searchQuery.isEmpty {
            return items.sort(on: selectedSortOption)
        }
        let filteredItems = items.compactMap { item in
            let titleContainQuery = item.title.range(of: searchQuery, options: .caseInsensitive) != nil
            let categoryTitleContainsQuery = item.category?.title.range(of: searchQuery, options: .caseInsensitive) != nil
            
            return (titleContainQuery || categoryTitleContainsQuery) ? item : nil
        }
        return filteredItems.sort(on: selectedSortOption)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if items.isEmpty {
                    ContentUnavailableView("To Do List Empty", systemImage: "checklist")
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            VStack {
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
                                
                                if let selectedPhotoData = item.image, let uiImage = UIImage(data: selectedPhotoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                        .onTapGesture {
                                            isImageViewerPresented = true
                                        }
                                        .fullScreenCover(isPresented: $isImageViewerPresented) {
                                            SwiftUIImageViewer(image: Image(uiImage: uiImage))
                                                .overlay(alignment: .topTrailing) {
                                                    closeButton
                                                }
                                        }
                                }
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
                    .animation(.easeIn, value: filteredItems)
                    .searchable(text: $searchQuery ,placement: .navigationBarDrawer,
                                prompt: "Search for a to do or a category")
                    .overlay {
                        if filteredItems.isEmpty {
                            ContentUnavailableView.search
                        }
                    }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button("New Category") {
                            showCreateCategory.toggle()
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Menu {
                            Picker("", selection: $selectedSortOption) {
                                ForEach(SortOption.allCases, id: \.rawValue) { option in
                                    Label(option.rawValue.capitalized, systemImage: option.systemImage)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                            
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .symbolVariant(.circle)
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
    
private var closeButton: some View {
        Button {
            isImageViewerPresented = false
        } label: {
           Image(systemName: "xmark")
                .font(.headline)
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
        .tint(.blue)
        .padding()

    }
}

#Preview {
    ContentView()
}

private extension [ToDo] {
    func sort(on option: SortOption) -> [ToDo] {
        switch option {
        case .title:
            self.sorted(by: {$0.title < $1.title})
        case .date:
            self.sorted(by: {$0.timestamp < $1.timestamp})
        case .category:
            self.sorted(by: {
                guard let firstItemTitle = $0.category?.title,
                      let secondItemTitle = $1.category?.title
                else { return false }
                return firstItemTitle < secondItemTitle
                
            })
        }
    }
}
