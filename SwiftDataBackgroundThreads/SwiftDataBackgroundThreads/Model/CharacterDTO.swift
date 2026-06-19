//
//  CharacterDTO.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 18/06/2026.
//
import Foundation
import SwiftData

struct CharacterDTO: Identifiable, Equatable, Hashable {
    let id: PersistentIdentifier?
    
    var name: String
    
    init(id: PersistentIdentifier?, name: String) {
        self.id = id
        self.name = name
    }

    init(model: Character) {
        id = model.id
        name = model.name
    }
}
