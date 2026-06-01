//
//  SwiftDataViewer.swift
//  RelationShipsTutorial
//
//  Created by Khawla Zarrami on 01/06/2026.
//

import Foundation
import SwiftData
import SwiftUI

struct SwiftDataViewer<Content: View>: View {
    private let content: Content
    private let preview: PreviewContainer
    private let items: [any PersistentModel]?

    init(
        preview: PreviewContainer,
        items: [any PersistentModel]? = nil,
        @ViewBuilder _ content:()-> Content
    ) {
        self.preview = preview
        self.items = items
        self.content = content()
    }
    
    var body: some View {
        content
            .modelContainer(preview.container)
            .onAppear {
                if let items {
                    preview.add(items)
                }
            }
    }
}
