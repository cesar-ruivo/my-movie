import Foundation
import UIKit

class HomeBuilder {
    
    static func build() -> UIViewController {
        
        // 1. Cria todas as peças
        let presenter = HomePresenter()
        let view = HomeViewController(presenter: presenter)
        let interactor = HomeInteractor()
        let router = HomeRouter()

        // 2. Conecta tudo (como plugar os cabos)

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
