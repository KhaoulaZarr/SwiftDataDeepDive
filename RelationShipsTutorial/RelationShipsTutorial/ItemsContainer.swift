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
            shouldCreateDefaults = false
            let categories = DefaultsJSON.decode(from: "CategoryDefaults", type: [Category].self)
            categories?.forEach({ container.mainContext.insert($0)})
            
            let items = DefaultsJSON.decode(from: "DefaultToDos", type: [ToDo].self)
            items?.forEach { item in
                container.mainContext.insert(item)
                item.category?.items?.append(item)
            }
        }
        return container
    }
}

extension Date {
    
    static func randomDateNextWeek() -> Date? {
        let calendar = Calendar.current
        let currentDate = Date.now
        guard let nextWeekStartDate = calendar.date(byAdding: .day, value: 7, to: currentDate) else {
            return nil
        }
        let randomTimeInterval = TimeInterval.random(in: 0..<7 * 24 * 60 * 60) // random Time within a week
        let randomDate = nextWeekStartDate.addingTimeInterval(randomTimeInterval)
        return randomDate
    }
}
