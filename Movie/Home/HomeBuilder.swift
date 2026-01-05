import Foundation
import UIKit

final class HomeBuilder {
    
    static func build() -> UIViewController {
        let networkService = NetworkService()
        let favoriteService = FavoriteService()
        
        let interactor = HomeInteractor(networkService: networkService, favoriteService: favoriteService)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let view = HomeViewController(presenter: presenter)
        
        interactor.setInteractorToPresenter(presenter)
        presenter.setViwToPresenter(view)
        router.viewController = view
        
        return view
    }
}

