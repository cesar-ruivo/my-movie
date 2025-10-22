import Foundation

class SearchPresenter {
    var view: SearchPresenterToViewProtocol?
    var interactor: SearchPresenterToInteractorProtocol?
    var router: SearchPresenterToRouterProtocol?
}

//MARK: - Comunicacao entre controller e presenter
extension SearchPresenter: SearchViewToPresenterProtocol {
    
}

//MARK: - Comunicacao entre interactor e presenter
extension SearchPresenter: SearchInteractorToPresenterProtocol {
    
}
