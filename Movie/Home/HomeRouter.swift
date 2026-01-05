import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func routeToDetails(with movie: Movie) {
        let detailsViewController = MovieDetailBuilder.build(with: movie)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToSearch() {
        let view = SeachBuilder.build()
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
    
    func routerToFavorite() {
        let view = FavoriteBuilder.build()
        viewController?.navigationController?.pushViewController(view, animated: true)
    }
}
