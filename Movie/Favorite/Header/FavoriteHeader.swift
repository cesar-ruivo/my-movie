import UIKit

class FavoriteHeader: UIView {
    private var theme: ThemeManager?
    weak var delegate: FavoriteHeaderProtocol?
    
    //MARK: - Componente de UI
    private lazy var favoriteLabelTitle: UILabel = {
        let view = UILabel()
        let style = theme?.textStyle(named: "title2")
        view.font = style?.font
        view.textColor = style?.color
        view.text = "Minha lista de favoritos"
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoriteButtonBack: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "chevron.left")
        let style = theme?.color(named: "white")
        button.setImage(starImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTappdButtonBack), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var favoriteStackViewMain: UIStackView = {
        let view = UIStackView(arrangedSubviews: [favoriteButtonBack, favoriteLabelTitle])
        view.alignment = .fill
        view.spacing = 8
        view.distribution = .fill
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    //MARK: - Cilco de vida
    init(theme: ThemeManager? = ThemeManager.shared) {
        super.init(frame: .zero)
        self.theme = theme
        self.backgroundColor = .black
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoriteHeader: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            favoriteStackViewMain.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            favoriteStackViewMain.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            favoriteStackViewMain.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            favoriteStackViewMain.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            favoriteButtonBack.widthAnchor.constraint(equalToConstant: 32),
            favoriteButtonBack.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupAddView() {
        addSubview(favoriteStackViewMain)
    }
}

extension FavoriteHeader {
    @objc func didTappdButtonBack() {
        delegate?.didTappedButtonBack()
    }
}
