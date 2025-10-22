import UIKit

class SearchViewController: UIViewController, SearchPresenterToViewProtocol {
    //MARK: - Conectar
    
    var presenter: SearchViewToPresenterProtocol!
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

