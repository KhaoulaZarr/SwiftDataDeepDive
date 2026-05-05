//
//  CategoriesJSONDecoder.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 05/05/2026.
//

import Foundation

struct CategoryResponse: Decodable {
    let title: String
}

struct CategoriesJSONDecoder {
    
    static func decode(from fileName: String) -> [CategoryResponse] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let categories = try? JSONDecoder().decode([CategoryResponse].self, from: data) else {
            return []
        }
        
        return categories
                                   
    }
}
