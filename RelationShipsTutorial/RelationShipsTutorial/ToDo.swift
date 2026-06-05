//
//  ToDo.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 15/04/2026.
//

import Foundation
import SwiftData
import UIKit



extension ToDo {
    static var dummy: ToDo {
        .init(title: "Item1",
              dueDate: .now,
              isCritical: true
        )
    }
}
