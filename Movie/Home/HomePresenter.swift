import Foundation

class HomePresenter {
    private weak var view: HomePresenterToViewProtocol?
    private var interactor: HomePresenterToInteractorProtocol
    private var router: HomePresenterToRouterProtocol
    private var activeSections: [HomeSections] = []
//    private var homeSectionStorage: HomeSectionStorageProtocol
    
    init(
        interactor: HomePresenterToInteractorProtocol,
        router: HomePresenterToRouterProtocol,
        homeSectionStorage: HomeSectionStorageProtocol = HomeSectionStorage()
    ) {
        self.interactor = interactor
        self.router = router
//        self.homeSectionStorage = homeSectionStorage
    }
    func setViwToPresenter(_ view: HomePresenterToViewProtocol) {
        self.view = view
    }
}

//MARK: - Comunicacao entre controller e presenter
extension HomePresenter: HomeViewToPresenterProtocol {
    func didSelectFavoriteIcone() {
        router.routerToFavorite()
    }
    
    func didSelectHomeHeaderIconSearch() {
        router.routeToSearch()
    }
    
    func fetchNumberOfList() -> Int {
        return activeSections.count
    }
    
    func getTitleFromMovies(section: Int) -> String {
        let position = getSectionType(for: section)
        
        switch position {
        case .nowPlaying:
            return ""
        case .popular:
            return "Recomendado para voce"
        case .topRate:
            return "Filmes em alta"
        }
    }
    //MARK: - Verificar se a lista de filmes esta vazia
    func getSectionType(for index: Int) -> HomeSections {
        if index < activeSections.count {
            return activeSections[index]
        }
        return .popular
    }
    
    //MARK: - Lista de filmes
    //pegar lista de filmes
    func getMovie(at indexPath: IndexPath) -> Movie? {
        let sectionType = getSectionType(for: indexPath.section)
        return interactor.getMovie(type: sectionType, row: indexPath.row)
    }
    // atualizar lista
    func requestMovieList() {
        interactor.fetchAllMovieLists()
    }
    // quantidade de itens na lista de filmes
    func requestSectionFromList(section: Int) -> Int {
        
        let position = getSectionType(for: section)
        switch position {
        case .nowPlaying:
            return min(5, interactor.getNumberOfNowPlayingMovies())
        case .popular:
            return interactor.getNumberOfPopularMovies()
        case .topRate:
            return interactor.getNumberOfTopRatedMovies()
        }
    }
    //MARK: - Favorito
    func toggleFavorite(at indexPath: IndexPath) {
            guard let targetMovie = getMovie(at: indexPath) else { return }
            
            let currentSectionType = getSectionType(for: indexPath.section)
            
            let isNowFavorite = interactor.toggleFavorite(type: currentSectionType, row: indexPath.row)
            
            let locations = interactor.getLocations(for: targetMovie.id)
            
            let indexPathsToUpdate: [IndexPath] = locations.compactMap { (sectionType, row) in
                guard let sectionIndex = activeSections.firstIndex(of: sectionType) else { return nil }
                return IndexPath(row: row, section: sectionIndex)
            }
        
            if indexPathsToUpdate.isEmpty {
                view?.updateSpecificIcon(at: [indexPath], isFavorite: isNowFavorite)
            } else {
                view?.updateSpecificIcon(at: indexPathsToUpdate, isFavorite: isNowFavorite)
            }
        }
    
    func isFavorite(at indexPath: IndexPath) -> Bool {
        let sectionType = getSectionType(for: indexPath.section)
        return interactor.isFavorite(type: sectionType, row: indexPath.row)
    }
    //MARK: - Navegacao tela
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movie = getMovie(at: indexPath) else { return }
        router.routeToDetails(with: movie)
    }
}

//MARK: - Comunicacao entre interactor e presenter
extension HomePresenter: HomeInteractorToPresenterProtocol {
    func requestDidFinishWithSuccess() {
        activeSections = []
        
        if interactor.getNumberOfNowPlayingMovies() > 0 {
            activeSections.append(.nowPlaying)
        }
        if interactor.getNumberOfPopularMovies() > 0 {
            activeSections.append(.popular)
        }
        if interactor.getNumberOfTopRatedMovies() > 0 {
            activeSections.append(.topRate)
        }
        view?.reloadMovieList()
    }
}
