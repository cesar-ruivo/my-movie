import Foundation

// View -> Presenter
protocol MovieDetailViewToPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapFavorite()
    func checkFavoriteStatus()
}
// Presenter -> Interactor
protocol MovieDetailPresenterToInteractorProtocol: AnyObject {
    func getMovieData() -> Movie
    func toggleFavorite()
    func isFavorite() -> Bool
}
// Interector -> Presenter
protocol MovieDetailInteractorToPresenterProtocol: AnyObject {
    func didUpdatefavoriteStatus(isFavorite: Bool)
}
// Presenter -> View
protocol MovieDetailPresenterToViewProtocol: AnyObject {
    func showMovieDetails(title: String, description: String, ratingText: String, imageURL: URL?)
    func updateFavoriteIcon(isFavorite: Bool)
}
// Presenter -> Router
protocol MovieDetailPresenterToRouterProtocol: AnyObject {
    func popViewController()
}
