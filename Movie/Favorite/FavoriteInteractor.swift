import Foundation

class FavoriteInteractor {
    weak var presenter: FavoriteInteractorToPresenterProtocol?
    private let favoriteService: FavoriteServiceProtocol
    private var movie: [Movie] = []
    
    init(
        favoriteService: FavoriteServiceProtocol
    ){
        self.favoriteService = favoriteService
    }
    
    func setInteractorToPresenter(_ presenter: FavoriteInteractorToPresenterProtocol) {
        self.presenter = presenter
    }
}
//MARK: - Metodos
extension FavoriteInteractor: FavoritePresenterToInteractorProtocol {
    func removeFavorite(row: Int) {
        guard row < movie.count else { return }
        
        let movieToDelete = movie[row]
        _ = favoriteService.toggleFavorite(movie: movieToDelete)
        movie.remove(at: row)
        presenter?.requestDidFinishWithSuccess()
    }
    
    func fetchMovieList() {
        unpackList()
        
        DispatchQueue.main.async {
            print("Filmes favoritos carregados")
            self.presenter?.requestDidFinishWithSuccess()
        }
    }
    
    func getMovie(type: FavoriteSection, row: Int) -> Movie? {
        guard row < movie.count else { return nil }
        
        return movie[row]
    }
    
    func getNumberOfFavoriteMovies() -> Int {
        return movie.count
    }
    
    
}

//MARK: - Metodos privados
private extension FavoriteInteractor {
    private func unpackList() {
        movie = favoriteService.getAllFavorites()
    }
}
