import Foundation
import UIKit

class SearchRouter: SearchPresenterToRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func routeToDetails(with movie: Movie) {
        let detailsViewController = MovieDetailBuilder.build(with: movie)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func demissScrenn() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
