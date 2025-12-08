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
        let viewControler = SeachBuilder.build()
        viewController?.navigationController?.pushViewController(viewControler, animated: true)
    }
}
