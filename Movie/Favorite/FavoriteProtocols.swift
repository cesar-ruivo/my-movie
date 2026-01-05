import Foundation

// View -> Presenter
protocol FavoriteViewToPresenterProtocol {
    func getSectionType(for index: Int) -> FavoriteSection
    func fetchNumberOfList() -> Int
    func requestSectionFromList(section: Int) -> Int
    func getMovie(at indexPath: IndexPath) -> Movie?
    func requestMovieList()
    func didSelectMovie(at indexPath: IndexPath)
    func didTappedBackButton()
    func deleteMovie(at indexPath: IndexPath)
}
// Presenter -> Interactor
protocol FavoritePresenterToInteractorProtocol: AnyObject {
    func getNumberOfFavoriteMovies() -> Int
    func getMovie(type: FavoriteSection, row: Int) -> Movie?
    func fetchMovieList()
    func removeFavorite(row: Int)
}
// Interactor -> Presenter
protocol FavoriteInteractorToPresenterProtocol: AnyObject {
    func requestDidFinishWithSuccess()
}
// Presenter -> View
protocol FavoritePresenterToViewProtocol: AnyObject {
    func reloadMovieList()
}
// Presenter -> Router
protocol FavoritePresenterToRouterProtocol: AnyObject {
    func routeToDetails(with movie: Movie)
    func didTappedBackButton()

}
