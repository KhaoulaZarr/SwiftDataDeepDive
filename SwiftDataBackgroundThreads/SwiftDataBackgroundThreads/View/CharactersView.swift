//
//  CharactersView.swift
//  SwiftDataBackgroundThreads
//
//  Created by Khawla Zarrami on 16/06/2026.
//

import SwiftUI
import SwiftData


private let colors: [Color] = [
    .brown,
    .cyan,
    .indigo,
    .teal,
    .blue,
    .green,
    .orange,
    .pink,
    .purple,
    .red
]

struct CharactersView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let viewModel: ContentViewModel
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.characters , id: \.self) {   item in
                       
                        Text("Character # \(item.name)")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity , maxHeight: .infinity)
                            .background(
                                colors[
                                    abs(item.name.hashValue) % colors.count
                                ].opacity(0.6)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .aspectRatio(1, contentMode: .fit)
            
                    }
                }
                .padding()
            }
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                       dismiss()
                    } label: {
                        Label("Cancel", systemImage:  "xmark")
                    }
                }
            }
            .task {
                    await viewModel.load()
            }
        }
    }
}

/*#Preview {
    CharactersView( )
        .modelContainer(for: Character.self, inMemory: true)
}*/
