import Foundation

// View -> Presenter
protocol HomeViewToPresenterProtocol {
    func getSectionType(for index: Int) -> HomeSections
    func requestSectionFromList(section: Int) -> Int
    func requestMovieList()
    func getMovie(at indexPath: IndexPath) -> Movie?
    func setViwToPresenter(_ view: HomePresenterToViewProtocol)
    // pegar tiutlo
    func getTitleFromMovies(section: Int) -> String
    
    func fetchNumberOfList() -> Int
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

}
// interector -> presenter
protocol HomeInteractorToPresenterProtocol: AnyObject {
    func requestDidFinishWithSuccess()
}
// Presenter -> View
protocol HomePresenterToViewProtocol: AnyObject {
    func reloadMovieList()
}
// Presenter -> Router
protocol HomePresenterToRouterProtocol {
    
}
