//
//  Character.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 16/06/2026.
//

import Foundation
import SwiftData

@Model
final class Character{
    
    @Attribute(.unique)
    var  name: String
    
    init(name: String) {
        self.name = name
    }
}
