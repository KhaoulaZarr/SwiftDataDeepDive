//
//  ToDo.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import Foundation
import SwiftData

@Model
final class ToDo {
    var title: String
    var timestamp: Date
    var isCritical: Bool
    var isCompleted: Bool
    
    @Attribute(.externalStorage)
    var image: Data?
    
    @Relationship(deleteRule: .nullify, inverse: \Category.items)
    var category: Category?
    
    init(title: String = "",
         timestamp: Date = .now,
         isCritical: Bool = false,
         isCompleted: Bool = false) {
        self.title = title
        self.timestamp = timestamp
        self.isCritical = isCritical
        self.isCompleted = isCompleted
    }
}

extension ToDo {
    static var dummy: ToDo {
        .init(title: "Item1",
              timestamp: .now,
              isCritical: true
        )
    }
}
