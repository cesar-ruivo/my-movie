import Foundation

class HomePresenter {
    private weak var view: HomePresenterToViewProtocol?
    private var interactor: HomePresenterToInteractorProtocol
    private var router: HomePresenterToRouterProtocol
    private var activeSections: [HomeSections] = []
    
    init(interactor: HomePresenterToInteractorProtocol, router: HomePresenterToRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    func setViwToPresenter(_ view: HomePresenterToViewProtocol) {
        self.view = view
    }
}

//MARK: - Comunicacao entre controller e presenter
extension HomePresenter: HomeViewToPresenterProtocol {
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
//            let count = interactor.getNumberOfNowPlayingMovies()
//            if count > 0 {
//                return min(5, count)
//            } else {
//                return 0
//            }
        case .popular:
            return interactor.getNumberOfPopularMovies()
        case .topRate:
            return interactor.getNumberOfTopRatedMovies()
        }
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
