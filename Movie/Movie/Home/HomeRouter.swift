import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}
