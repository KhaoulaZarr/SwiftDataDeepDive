//
//  CachingAPIResponseSwiftDataApp.swift
//  CachingAPIResponseSwiftData
//
//  Created by Khawla Zarrami on 06/05/2026.
//

import SwiftUI
import SwiftData

@main
struct CachingAPIResponseSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Product.self])
        }
    }
}
