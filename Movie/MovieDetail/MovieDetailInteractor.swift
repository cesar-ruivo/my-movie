import UIKit

class MovieDetailInteractor: MovieDetailPresenterToInteractorProtocol {
    //MARK: - Conectar
    weak var presenter: MovieDetailInteractorToPresenterProtocol?
    private let favoriteService: FavoriteServiceProtocol
    private let movie: Movie
    
    //MARK: - Inicializador
    init(movie: Movie, favoriteService: FavoriteServiceProtocol) {
        self.movie = movie
        self.favoriteService = favoriteService
    }

    func setPresenter(_ presenter: MovieDetailInteractorToPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: - metodos
    // Lógica de Favorito (Igual à Home)
    func toggleFavorite() {
        let isFav = favoriteService.toggleFavorite(movie: movie)
        presenter?.didUpdatefavoriteStatus(isFavorite: isFav)
    }
    
    func isFavorite() -> Bool {
        return favoriteService.isFavorite(movie: movie)
    }
    
    func getMovieData() -> Movie {
        return movie
    }
}

