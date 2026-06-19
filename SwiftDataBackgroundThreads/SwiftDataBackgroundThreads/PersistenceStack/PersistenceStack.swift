//
//  PersistantStack.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 18/06/2026.
//

import Foundation
import SwiftData

final class PersistenceStack: Sendable {
    static let shared: PersistenceStack = PersistenceStack()
    let modelContainer: ModelContainer

    private init() {
        do {
            let schema = Schema([
                Character.self,
            ])

            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }
}
