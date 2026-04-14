//
//  MyToDosApp.swift
//  MyToDos
//
//  Created by Khawla Zarrami on 14/04/2026.
//

import SwiftUI
import SwiftData

@main
struct MyToDosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDoItem.self)
        }
        
    }
}
