import Foundation

// View -> Presenter
protocol SearchViewToPresenterProtocol{
    func requestMovieList()
    func getSectionType(for index: Int) -> SearchSection
    func fetchNumberOfList() -> Int
    func requestSetionFromList(section: Int) -> Int
    func getMovie(at indexPath: IndexPath) -> Movie?
    func isFavorite(at indexPath: IndexPath) -> Bool
    func getTitleFromMovies(section: Int) -> String
    func toggleFavorite(at indexPath: IndexPath)
    func didSelectMovie(at indexPath: IndexPath)
}
// Presenter -> Interactor
protocol SearchPresenterToInteractorProtocol: AnyObject  {
    func fetchAllMovieList()
    func getMovie(type: SearchSection, row: Int) -> Movie?
    func getNumberOfNowPlayingMovies() -> Int
    func getNumberOfPopularMovies() -> Int
    func getNumberOfTopRateMovies() -> Int
    func isFavorite(type: SearchSection, row: Int) -> Bool
    func toggleFavorite(type: SearchSection, row: Int)
}
// Interactor -> Presenter
protocol SearchInteractorToPresenterProtocol: AnyObject  {
    func requestDidFinishWithSuccess()
}
// Presenter -> View
protocol SearchPresenterToViewProtocol: AnyObject  {
    func reloadMovieList()
}
// Presenter -> Router
protocol SearchPresenterToRouterProtocol: AnyObject  {
    func routeToDetails(with movie: Movie)
}
