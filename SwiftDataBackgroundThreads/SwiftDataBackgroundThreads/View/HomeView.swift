//
//  HomeView.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 16/06/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showCharacters: Bool = false
    @State private var viewModel = ContentViewModel(service: ItemActor(modelContainer: PersistenceStack.shared.modelContainer))
    
    var body: some View {
        Button {
            showCharacters.toggle()
        } label: {
            Text("Show Characters")
        }
        .sheet(isPresented: $showCharacters) {
            CharactersView(viewModel: viewModel)
        }
        .task(priority: .background, {
            let characters = (0...10000).map{
                
                CharacterDTO(id: nil, name: "\($0)")
            }
            await viewModel.addCharacters(items: characters)
            
        })
        
    }
}

#Preview {
    HomeView()
}
