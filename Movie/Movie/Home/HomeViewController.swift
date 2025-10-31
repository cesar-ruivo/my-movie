import UIKit

class HomeViewController: UIViewController, HomePresenterToViewProtocol {
    //MARK: - Conectar
    
    private var presenter: HomeViewToPresenterProtocol
    private var theme: ThemeManager

    init(presenter: HomeViewToPresenterProtocol, theme: ThemeManager = ThemeManager.shared) {
        self.presenter = presenter
        self.theme = theme

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Componentes
    lazy var titleLabel: UILabel = {
        let i = theme.textStyle(named: "title")
        let label = UILabel()
        label.font = i?.font
        label.textColor = i?.color
        label.text = "teste de tema"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
        
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor(hex: "1A1A1A")
    }
}

extension HomeViewController: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupAddView() {
        view.addSubview(titleLabel)
    }
}

