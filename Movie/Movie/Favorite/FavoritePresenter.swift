import Foundation

class FavoritePresenter {
    var view: FavoritePresenterToViewProtocol?
    var interactor: FavoritePresenterToInteractorProtocol?
    var router: FavoritePresenterToRouterProtocol?
}

//MARK: - Comunicacao entre controller e presenter
extension FavoritePresenter: FavoriteViewToPresenterProtocol {
    
}

//MARK: - Comunicacao entre interactor e presenter
extension FavoritePresenter: FavoriteInteractorToPresenterProtocol {
    
}
