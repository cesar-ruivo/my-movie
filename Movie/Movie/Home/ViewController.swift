import UIKit

class HomeViewController: UIViewController, HomePresenterToViewProtocol {
    //MARK: - Conectar
    
    var presenter: HomeViewToPresenterProtocol!
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

