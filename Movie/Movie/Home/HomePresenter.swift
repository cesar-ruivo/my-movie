import Foundation

class HomePresenter {
    var view: HomePresenterToViewProtocol?
    var interactor: HomePresenterToInteractorProtocol?
    var router: HomePresenterToRouterProtocol?
}

//MARK: - Comunicacao entre controller e presenter
extension HomePresenter: HomeViewToPresenterProtocol {
    
}

//MARK: - Comunicacao entre interactor e presenter
extension HomePresenter: HomeInteractorToPresenterProtocol {
    
}
