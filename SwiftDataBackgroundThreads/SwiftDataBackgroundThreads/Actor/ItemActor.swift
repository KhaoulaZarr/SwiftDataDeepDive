//
//  ItemActor.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 18/06/2026.
//
import Foundation
import SwiftData

@ModelActor
actor ItemActor: ItemRepository {
    
    func fetchCharacters() async throws -> [CharacterDTO] {
        try modelContext.fetch(FetchDescriptor<Character>(sortBy: [SortDescriptor(\.name, order: .reverse)])).map { CharacterDTO(model: $0) }
    }
    
    func insert(character: CharacterDTO) async throws {
        let model = fetchUpdatedCharacter(dto: character)
        
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func delete(character: CharacterDTO) async throws {
        guard let model = fetchCharacter(id: character.id) else { return }
        
        modelContext.delete(model)
        try modelContext.save()
    }
    
    private func fetchUpdatedCharacter(dto: CharacterDTO) -> Character {
        guard let model = fetchCharacter(id: dto.id) else {
            return Character(name: dto.name)
        }
        
        model.name = dto.name
        return model
    }
    
    private func fetchCharacter(id: PersistentIdentifier?) -> Character? {
        guard let id else { return nil }
        
        return modelContext.model(for: id) as? Character
    }
}
