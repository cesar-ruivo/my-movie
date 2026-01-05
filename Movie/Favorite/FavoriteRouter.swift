import Foundation
import UIKit

class FavoriteRouter: FavoritePresenterToRouterProtocol {
    weak var viewController: UIViewController?
    
    func routeToDetails(with movie: Movie) {
        let detailsViewController = MovieDetailBuilder.build(with: movie)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func didTappedBackButton() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
