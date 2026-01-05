import UIKit

class FavoriteViewController: UIViewController, FavoritePresenterToViewProtocol {
    //MARK: - Conectar
    
    var presenter: FavoriteViewToPresenterProtocol!
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
