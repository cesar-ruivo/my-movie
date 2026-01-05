import Foundation

protocol FavoriteServiceProtocol {
    func toggleFavorite(movie: Movie) -> Bool
    func isFavorite(movie: Movie) -> Bool
    func getAllFavorites() -> [Movie]
}
