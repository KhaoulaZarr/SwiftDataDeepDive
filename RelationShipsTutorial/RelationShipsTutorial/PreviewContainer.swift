//
//  PreviewContainer.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 01/06/2026.
//

import Foundation
import SwiftData

struct PreviewContainer {
    
    let container: ModelContainer!
    
    init(_ types: [any PersistentModel.Type], isStoredInMemoryOnly: Bool = true) {
        let schema = Schema(types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [config])
    }
    
    func add(_ items: [any PersistentModel]) {
        Task { @MainActor in
            items.forEach{container.mainContext.insert($0) }
        }
    }
    
}
