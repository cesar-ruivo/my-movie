import Foundation
import UIKit

class MovieDetailBuilder {
    
    static func build(with movie: Movie) -> UIViewController {
        let favoriteService = FavoriteService()
        let interactor = MovieDetailInteractor(movie: movie, favoriteService: favoriteService)
        
        let router = MovieDetailRouter()
        let presenter = MovieDetailPresenter(interactor: interactor, router: router)
        let view = MovieDetailViewController(presenter: presenter)
        
        interactor.setPresenter(presenter)
        presenter.setView(view)
        router.viewController = view
        
        return view
    }
}
