//
//  RelationShipsTutorialApp.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData

@main
struct RelationShipsTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ToDo.self)
        }
    }
}
