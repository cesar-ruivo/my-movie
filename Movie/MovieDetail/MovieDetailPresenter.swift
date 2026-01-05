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
        
        let isFav = interactor.isFavorite()
        
        let ratingText = "Nota " + String(format: "%.1f", movie.vote_average)
        var url: URL?
        if let path = movie.poster_path {
            url = Enviroment.URLImage?.appendingPathComponent(path)
        }
        
        view?.updateFavoriteIcon(isFavorite: isFav)
        view? .showMovieDetails(title: movie.title, description: movie.overview, ratingText: ratingText, imageURL: url)
    }
    
    func didTapFavorite() {
        interactor.toggleFavorite()
    }
}

//MARK: - Comunicacao entre interactor e presenter
extension MovieDetailPresenter: MovieDetailInteractorToPresenterProtocol {
    func didUpdatefavoriteStatus(isFavorite: Bool) {
        view?.updateFavoriteIcon(isFavorite: isFavorite)
    }
}
