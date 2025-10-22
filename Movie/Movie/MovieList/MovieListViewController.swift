import UIKit

class MovieListViewController: UIViewController, MovieListPresenterToViewProtocol {
    //MARK: - Conectar
    
    var presenter: MovieListViewToPresenterProtocol!
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

