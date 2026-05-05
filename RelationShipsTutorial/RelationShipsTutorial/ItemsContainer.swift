//
//  ItemsContainer.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 05/05/2026.
//

import Foundation
import SwiftData

actor ItemsContainer {
    
    @MainActor
    static func create(shouldCreateDefaults: inout Bool) -> ModelContainer {
        let scheme = Schema([ToDo.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: scheme, configurations: configuration)
        if shouldCreateDefaults {
            Category.defaults.forEach { container.mainContext.insert($0)}
            shouldCreateDefaults = false
        }
        return container
    }
}
