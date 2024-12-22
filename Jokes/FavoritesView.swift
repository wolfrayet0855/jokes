import SwiftUI

struct FavoritesView: View {
    @ObservedObject var jokeVM: JokeViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(jokeVM.favoriteJokes, id: \.setup) { joke in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Setup: \(joke.setup)")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Punchline: \(joke.punchline)")
                            .font(.subheadline)
                            .foregroundColor(.cyan)
                    }
                }
                .onDelete(perform: deleteJoke)
            }
            // Ensure the list is scrollable and stylized
            .listStyle(.insetGrouped)
            .navigationTitle("Favorite Jokes")
        }
    }
    
    private func deleteJoke(at offsets: IndexSet) {
        jokeVM.favoriteJokes.remove(atOffsets: offsets)
        jokeVM.saveFavorites()
    }
}
