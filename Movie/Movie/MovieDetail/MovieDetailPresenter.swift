import Foundation

class MovieDetailPresenter {
    weak var view: MovieDetailPresenterToViewProtocol?
    private var interactor: MovieDetailPresenterToInteractorProtocol
    var router: MovieDetailPresenterToRouterProtocol
    
    init(
        interactor: MovieDetailPresenterToInteractorProtocol,
        router: MovieDetailPresenterToRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func setView(_ view: MovieDetailPresenterToViewProtocol) {
        self.view = view
    }
}

//MARK: - Comunicacao entre controller e presenter
extension MovieDetailPresenter: MovieDetailViewToPresenterProtocol {
    func viewDidLoad() {
        let movie = interactor.getMovieData()
        let ratingText = "Nota " + String(format: "%.1f", movie.vote_average)
        let url = Enviroment.URLImage?.appendingPathComponent(movie.poster_path)
        
        view? .showMovieDetails(title: movie.title, description: movie.overview, ratingText: ratingText, imageURL: url)
    }
    
    func didTapFavorite() {
        interactor.toggleFavorite()
    }
    
    func checkFavoriteStatus() {
        let isFav = interactor.isFavorite()
        view?.updateFavoriteIcon(isFavorite: isFav)
    }
    
    
}

//MARK: - Comunicacao entre interactor e presenter
extension MovieDetailPresenter: MovieDetailInteractorToPresenterProtocol {
    func didUpdatefavoriteStatus(isFavorite: Bool) {
        view?.updateFavoriteIcon(isFavorite: isFavorite)
    }
    
    
}
