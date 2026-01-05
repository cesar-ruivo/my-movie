import Foundation

class SearchPresenter {
    weak var view: SearchPresenterToViewProtocol?
    private var interactor: SearchPresenterToInteractorProtocol
    private var router: SearchPresenterToRouterProtocol
    
    private var activeSection: [SearchSection] = []
    
    init(
        interactor: SearchPresenterToInteractorProtocol,
        router: SearchPresenterToRouterProtocol
    ){
        self.interactor = interactor
        self.router = router
    }
    
    func setView(_ view: SearchPresenterToViewProtocol) {
        self.view = view
    }
}

//MARK: - Comunicacao entre controller e presenter
extension SearchPresenter: SearchViewToPresenterProtocol {
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movie = getMovie(at: indexPath) else { return }
        router.routeToDetails(with: movie)
    }
    
    func toggleFavorite(at indexPath: IndexPath) {
        let sectionType = getSectionType(for: indexPath.section)
        interactor.toggleFavorite(type: sectionType, row: indexPath.row)
    }
    
    func getTitleFromMovies(section: Int) -> String {
        let position = getSectionType(for: section)
        
        switch position {
        case .nowPlaying:
            return "Sendo assistido agora"
        case .popular:
            return "Recomendado para voce"
        case .topRate:
            return "Filmes em alta"
        }
    }

    func isFavorite(at indexPath: IndexPath) -> Bool {
        let sectionType = getSectionType(for: indexPath.section)
        return interactor.isFavorite(type: sectionType, row: indexPath.row)
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie? {
        let sectionType = getSectionType(for: indexPath.section)
        return interactor.getMovie(type: sectionType, row: indexPath.row)
    }
    
    func requestSetionFromList(section: Int) -> Int {
        let position = getSectionType(for: section)
        
        switch position {
        case .nowPlaying:
            return interactor.getNumberOfNowPlayingMovies()
        case .popular:
            return interactor.getNumberOfPopularMovies()
        case .topRate:
            return interactor.getNumberOfTopRateMovies()
        }
    }
    
    func fetchNumberOfList() -> Int {
        return activeSection.count
    }
    
    func requestMovieList() {
        interactor.fetchAllMovieList()
    }
    
    func getSectionType(for index: Int) -> SearchSection {
        if index < activeSection.count {
            return activeSection[index]
        }
        return .popular
    }
}

//MARK: - Comunicacao entre interactor e presenter
extension SearchPresenter: SearchInteractorToPresenterProtocol {

    func requestDidFinishWithSuccess() {
        activeSection = []
        
        if interactor.getNumberOfNowPlayingMovies() > 0 {
            activeSection.append(.nowPlaying)
        }
        if interactor.getNumberOfPopularMovies() > 0 {
            activeSection.append(.popular)
        }
        if interactor.getNumberOfTopRateMovies() > 0 {
            activeSection.append(.topRate)
        }
        view?.reloadMovieList()
    }
}
