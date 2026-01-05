import Foundation
import UIKit

class FavoriteBuilder {
    
    static func build() -> UIViewController {
        
        // 1. Cria todas as peças
        let view = FavoriteViewController()
        let presenter = FavoritePresenter()
        let interactor = FavoriteInteractor()
        let router = FavoriteRouter()

        // 2. Conecta tudo (como plugar os cabos)
        
        // View -> Presenter
        view.presenter = presenter

        // Presenter -> View
        presenter.view = view
        
        // Presenter -> Interactor
        presenter.interactor = interactor
        
        // Presenter -> Router
        presenter.router = router

        // Interactor -> Presenter
        interactor.presenter = presenter
        
        // Router -> View (para o router saber de onde navegar)
        router.viewController = view

        // 3. Retorna a View pronta
        return view
    }
}
