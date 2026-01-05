import Foundation
import UIKit

final class HomeBuilder {
    
    static func build() -> UIViewController {
        // Dependência concreta
        let networkService = NetworkService()
        let favoriteService = FavoriteService()
        
        // Cria as peças que não precisam de ciclos imediatos
        let interactor = HomeInteractor(networkService: networkService, favoriteService: favoriteService)
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let view = HomeViewController(presenter: presenter)
        
        // Conecta as referências bidirecionais de forma segura
        interactor.setInteractorToPresenter(presenter)
        presenter.setViwToPresenter(view)
        router.viewController = view
        
        return view
    }
}

