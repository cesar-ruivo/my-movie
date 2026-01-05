import Foundation
import UIKit

class FavoriteBuilder {
    
    static func build() -> UIViewController {
        let favoriteService = FavoriteService()
        
        let interactor = FavoriteInteractor(favoriteService: favoriteService)
        let router = FavoriteRouter()
        let presenter = FavoritePresenter(interactor: interactor, router: router)
        let view = FavoriteViewController(presenter: presenter)
        
        interactor.setInteractorToPresenter(presenter)
        presenter.setView(view)
        router.viewController = view
        
        return view
    }
}
