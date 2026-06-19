//
//  ContentViewModel.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 18/06/2026.
//

import Foundation
import SwiftData

@MainActor @Observable
class ContentViewModel {
    
    private(set) var characters:[CharacterDTO] = []
    
    let service: ItemRepository
    
    init(service: ItemRepository) {
        self.service = service
    }
    
    func load() async {
        characters = (try? await fetchData()) ?? []
    }
    
    nonisolated func fetchData() async throws -> [CharacterDTO] {
        return try await service.fetchCharacters()
    }
    
    func addCharacters(items: [CharacterDTO]) async {
        for item in items {
            try? await service.insert(character: item)
        }
        
        await load()
    }
    
    func delete(offsets: IndexSet) async {
        for index in offsets {
            try? await service.delete(character: characters[index])
        }

        await load()
    }
    
}
