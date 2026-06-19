//
//  SwiftDataBackgroundThreadsApp.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 16/06/2026.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataBackgroundThreadsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                
        }
        .modelContainer(PersistenceStack.shared.modelContainer)
    }
}
