import Foundation

class FavoritePresenter {
    weak var view: FavoritePresenterToViewProtocol?
    private var interactor: FavoritePresenterToInteractorProtocol
    private var router: FavoritePresenterToRouterProtocol
    private var activeSections: [FavoriteSection] = []
    
    init(
        interactor: FavoritePresenterToInteractorProtocol,
        router: FavoritePresenterToRouterProtocol
    ){
        self.interactor = interactor
        self.router = router
    }
    
    func setView(_ view: FavoritePresenterToViewProtocol) {
        self.view = view
    }
}

//MARK: - Comunicacao entre controller e presenter
extension FavoritePresenter: FavoriteViewToPresenterProtocol {
    func deleteMovie(at indexPath: IndexPath) {
        interactor.removeFavorite(row: indexPath.row)
    }
    
    func didTappedBackButton() {
        router.didTappedBackButton()
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movie = getMovie(at: indexPath) else { return }
        router.routeToDetails(with: movie)
    }
    
    func requestMovieList() {
        interactor.fetchMovieList()
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie? {
        let sectionType = getSectionType(for: indexPath.section)
        return interactor.getMovie(type: sectionType, row: indexPath.row)
    }
    
    func requestSectionFromList(section: Int) -> Int {
        let position = getSectionType(for: section)
        
        switch position {
        case .favorite:
            return interactor.getNumberOfFavoriteMovies()
        }
    }
    
    func fetchNumberOfList() -> Int {
        return activeSections.count
    }
    
    func getSectionType(for index: Int) -> FavoriteSection {
        if index < activeSections.count {
            return activeSections[index]
        }
        return .favorite
    }
    

    
    
}

//MARK: - Comunicacao entre interactor e presenter
extension FavoritePresenter: FavoriteInteractorToPresenterProtocol {
    func requestDidFinishWithSuccess() {
        print("Presenter - O interactor Avisou que terminou")
        activeSections = []
        
        if interactor.getNumberOfFavoriteMovies() > 0 {
            activeSections.append(.favorite)
        }
        
        view?.reloadMovieList()
    }
}
