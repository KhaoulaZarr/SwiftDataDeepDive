//
//  VersionedSchemaV3.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 05/06/2026.
//

import Foundation
import SwiftData
import UIKit

enum ToDoSchemaV3: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [ToDo.self, Category.self]
    }
    
    static var versionIdentifier: Schema.Version = .init(1, 1, 0) // major  minor patch
}

extension ToDoSchemaV3 {
    
    @Model
    final class ToDo: Codable {
        var title: String
        @Attribute(originalName: "timestamp")
        var dueDate: Date
        var isCritical: Bool
        var isCompleted: Bool
        var isFlagged: Bool = false
        var isArchived: Bool = false
        
        @Attribute(.externalStorage)
        var image: Data?
        
        @Relationship(deleteRule: .nullify, inverse: \Category.items)
        var category: Category?
        
        init(title: String = "",
             dueDate: Date = .now,
             isCritical: Bool = false,
             isCompleted: Bool = false) {
            self.title = title
            self.dueDate = dueDate
            self.isCritical = isCritical
            self.isCompleted = isCompleted
        }
        
        enum CodingKeys: String, CodingKey {
            case title
            case timestamp
            case isCritical
            case isCompleted
            case category
            case imageName
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
            self.dueDate = Date.randomDateNextWeek() ?? Date.now
            self.isCritical = try container.decode(Bool.self, forKey: .isCritical)
            self.isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
            self.category = try container.decodeIfPresent(Category.self, forKey: .category)
            if let imageName = try? container.decode(String.self, forKey: .imageName),
               let image = UIImage(named: imageName) {
                self.image = image.jpegData(compressionQuality: 0.8)
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(dueDate, forKey: .timestamp)
            try container.encode(isCritical, forKey: .isCritical)
            try container.encode(isCompleted, forKey: .isCompleted)
            try container.encode(category, forKey: .category)
        }
    }
    
    
    @Model
    class Category: Codable {
        @Attribute(.unique)
        var title: String
        
        
        var items: [ToDo]?
        
        init(title: String = "") {
            self.title = title
        }
        
        enum CodingKeys: String, CodingKey {
            case title
        }
        
        required init(from decoder:  Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
        }
    }
}
