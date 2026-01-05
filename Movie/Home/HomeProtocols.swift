import Foundation

// View -> Presenter
protocol HomeViewToPresenterProtocol {
    func getSectionType(for index: Int) -> HomeSections
    func requestSectionFromList(section: Int) -> Int
    func requestMovieList()
    func getMovie(at indexPath: IndexPath) -> Movie?
    func setViwToPresenter(_ view: HomePresenterToViewProtocol)
    func getTitleFromMovies(section: Int) -> String
    func toggleFavorite(at indexPath: IndexPath)
    func isFavorite(at indexPath: IndexPath) -> Bool
    func fetchNumberOfList() -> Int
    func didSelectMovie(at indexPath: IndexPath)
    func didSelectHomeHeaderIconSearch()
    func didSelectFavoriteIcone()
}
// Presenter -> interector
protocol HomePresenterToInteractorProtocol {
    // lista de filme
    func setInteractorToPresenter(_ presenter: HomeInteractorToPresenterProtocol)
    func getNumberOfNowPlayingMovies() -> Int
    func getNumberOfTopRatedMovies() -> Int
    func getNumberOfPopularMovies() -> Int
    // pegar a lista de filmes
    func fetchAllMovieLists()
    func getMovie(type: HomeSections, row: Int) -> Movie?
    // favorito
    func toggleFavorite(type: HomeSections, row: Int) -> Bool
    func isFavorite(type: HomeSections, row: Int) -> Bool
    func getLocations(for movieID: Int) -> [(section: HomeSections, row: Int)]
}
// interector -> presenter
protocol HomeInteractorToPresenterProtocol: AnyObject {
    func requestDidFinishWithSuccess()
}
// Presenter -> View
protocol HomePresenterToViewProtocol: AnyObject {
    func reloadMovieList()
    func updateSpecificIcon(at indexPaths: [IndexPath], isFavorite: Bool)
}
// Presenter -> Router
protocol HomePresenterToRouterProtocol {
    func routeToDetails(with movie: Movie)
    func routeToSearch()
    func routerToFavorite()
}
