import Foundation

class MovieListPresenter {
    var view: MovieListPresenterToViewProtocol?
    var interactor: MovieListPresenterToInteractorProtocol?
    var router: MovieListPresenterToRouterProtocol?
}

//MARK: - Comunicacao entre controller e presenter
extension MovieListPresenter: MovieListViewToPresenterProtocol {
    
}

//MARK: - Comunicacao entre interactor e presenter
extension MovieListPresenter: MovieListInteractorToPresenterProtocol {
    
}
