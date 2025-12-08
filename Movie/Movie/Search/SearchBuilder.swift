import Foundation
import UIKit

class SeachBuilder {
    
    static func build() -> UIViewController {
        let favoriteService = FavoriteService()
        let networkService = NetworkService()
        
        let interactor = SearchInteractor(favoriteService: favoriteService, networkService: networkService)
        let router = SearchRouter()
        let presenter = SearchPresenter(interactor: interactor, router: router)
        let view = SearchViewController(presenter: presenter)
        
        interactor.setInteractorToPresenter(presenter)
        presenter.setView(view)
        router.viewController = view
        
        return view
    }
}
