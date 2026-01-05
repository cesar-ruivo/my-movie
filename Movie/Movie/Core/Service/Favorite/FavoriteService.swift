import Foundation

final class FavoriteService: FavoriteServiceProtocol {
    private let key = "favorite_movies_list"
    private let defaults = UserDefaults.standard
    
    private func save(movies: [Movie]) {
        do {
            let data = try JSONEncoder().encode(movies)
            defaults.set(data, forKey: key)
        } catch {
            print("Erro ao salvar favoritos: \(error)")
        }
    }
    // adiciona ou remove, se for verdadeiro salva se for falso foi removido
    func toggleFavorite(movie: Movie) -> Bool {
        var favorites = getAllFavorites()
        let isNowFavorite: Bool
        
        if isFavorite(movie: movie) {
            favorites.removeAll { $0.title == movie.title }
            isNowFavorite = false
        } else {
            favorites.append(movie)
            isNowFavorite = true
        }
        
        save(movies: favorites)
        
        return isNowFavorite
    }
    // verifica se o filme já foi favoritado
    func isFavorite(movie: Movie) -> Bool {
        let favorites = getAllFavorites()
        return favorites.contains { $0.title == movie.title }
    }
    // Busca todos os favoritos salvos
    func getAllFavorites() -> [Movie] {
        guard let data = defaults.data(forKey: key) else { return [] }
        
        do {
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return movies
        } catch {
            print("Erro ao ler favoritos: \(error)")
            return []
        }
    }
}
