import UIKit

class SearchViewController: UIViewController, SearchPresenterToViewProtocol {
    //MARK: - Conectar
    
    private var presenter: SearchViewToPresenterProtocol!
    //MARK: - init
    init(presenter: SearchViewToPresenterProtocol!) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

