//
//  ContentView.swift
//  CachingAPIResponseSwiftData
//
//  Created by Khawla Zarrami on 06/05/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modalContext
    @Query(sort: \Product.id) private var products :[Product]
    
    @AppStorage("lastFetched") private var lastFetched: Double = Date.now.timeIntervalSince1970
    @State private var isLoading: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { item in
                    VStack(alignment: .leading) {
                       /* Rectangle()
                            .fill(.blue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)*/
                        AsyncImage(url: .init(string: item.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)

                        
                        Text(item.title)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                            .padding(.top)
                        
                        
                    }
                    .padding(.bottom)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            .navigationTitle("Posts")
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .task {
                do {
                    isLoading = true
                    defer { isLoading = false }
                    if hasExceededLimit() || products.isEmpty {
                        clearProducts()
                        try await fetchProducts()
                    }
                    
                }catch {
                   print(error)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Product.self])
}

@Model
class Product: Codable, Identifiable {
    
    @Attribute(.unique)
    var id: Int?
    var title: String
    var desc: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case desc = "description"
        case image
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.desc = try container.decode(String.self, forKey: .desc)
        self.image = try container.decode(String.self, forKey: .image)
        
    }
    
    func encode(to encoder: any Encoder) throws {
        // TODO: Handle encoding if you need to here
    }
    
    
}

extension ContentView {
    
    func fetchProducts() async throws {
        let url = URL(string: "https://fakestoreapi.com/products")!
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let products = try JSONDecoder().decode([Product].self, from: data)
        products.forEach{ modalContext.insert($0)}
        
        lastFetched = Date.now.timeIntervalSince1970
    }
    
    func hasExceededLimit() -> Bool {
       let timeLimit = 300 // 5 mins  = 300 Seconds
       let currentTime = Date.now
       let lastFetchedTime = Date(timeIntervalSince1970: lastFetched)
        
        guard let differenceInMins = Calendar.current.dateComponents([.second], from: lastFetchedTime, to: currentTime).second
        else {
            return false
        }
        return differenceInMins >= timeLimit
        
    }
    
    func clearProducts() {
        _ = try? modalContext.delete(model: Product.self)
    }
}
