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
            let categories = CategoriesJSONDecoder.decode(from: "CategoryDefaults")
            if categories.isEmpty == false {
                categories.forEach { item in
                    let category = Category(title: item.title)
                    container.mainContext.insert(category)
                }
            }
            shouldCreateDefaults = false
        }
        return container
    }
}
