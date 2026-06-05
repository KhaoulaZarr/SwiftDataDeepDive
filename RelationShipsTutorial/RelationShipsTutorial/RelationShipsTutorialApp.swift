//
//  RelationShipsTutorialApp.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import SwiftUI
import SwiftData

// MARK: SwiftData Models

typealias ToDo = ToDoSchemaV3.ToDo
typealias Category = ToDoSchemaV3.Category

// MARK: Migration Plan

enum ToDosMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] {
        [
            ToDoSchemaV1.self,
            ToDoSchemaV2.self,
            ToDoSchemaV3.self
        ]
    }
    
    static var stages: [MigrationStage] {
        [
            migrateV1toV2,
            migrateV2toV3
        ]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: ToDoSchemaV1.self,
        toVersion: ToDoSchemaV2.self
    )
    
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: ToDoSchemaV2.self,
        toVersion: ToDoSchemaV3.self,
        willMigrate: nil) { context in
            
            let items = try? context.fetch(FetchDescriptor<ToDoSchemaV3.ToDo>())
            items?.forEach { item in
                item.isFlagged = false
                item.isArchived = false
            }
            
            try? context.save()
        }
    
    
}

@main
struct RelationShipsTutorialApp: App {
    @AppStorage("isFirstTimeLaunch") private var isFirstTimeLaunch:Bool = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirstTimeLaunch))
        }
    }
}
