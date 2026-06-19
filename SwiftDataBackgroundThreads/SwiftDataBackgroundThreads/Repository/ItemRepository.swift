//
//  ItemRepository.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 18/06/2026.
//

import Foundation
import SwiftData

protocol ItemRepository: Sendable {

    func fetchCharacters() async throws -> [CharacterDTO]
    
    func insert(character: CharacterDTO) async throws
    
    func delete(character: CharacterDTO) async throws
}
