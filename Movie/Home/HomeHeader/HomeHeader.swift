import Foundation
import UIKit

final class HomeHeader: UIView {
    private var theme: ThemeManager?
    weak var delegate: HomeHeaderDelegateProtocol?
    
    //MARK: - Componentes de UI
    private lazy var homeLabelTitle: UILabel = {
        let label = UILabel()
        let style = theme?.textStyle(named: "title4")
        label.text = "Bem vindo"
        label.font = style?.font
        label.textColor = style?.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var HomeLabelName: UILabel = {
        let label = UILabel()
        let style = theme?.textStyle(named: "title3")
        label.text = "César Ruivo"
        label.font = style?.font
        label.textColor = style?.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var HomeButtonFavorite: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "star")
        let style = theme?.color(named: "white")
        button.setImage(starImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonFavoriteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private lazy var HomeButtonSearch: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "magnifyingglass")
        let style = theme?.color(named: "white")
        button.setImage(starImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonSearchTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    //MARK: - stackView
    
    private lazy var homeStackViewText: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var homeStackViewGeral: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - init
    init(theme: ThemeManager = ThemeManager.shared) {
        super.init(frame: .zero)
        self.theme = theme
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeHeader: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            HomeButtonSearch.widthAnchor.constraint(equalToConstant: 32),
            HomeButtonSearch.heightAnchor.constraint(equalToConstant: 32),
            
            HomeButtonFavorite.widthAnchor.constraint(equalToConstant: 32),
            HomeButtonFavorite.heightAnchor.constraint(equalToConstant: 32),
            
            homeStackViewGeral.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            homeStackViewGeral.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            homeStackViewGeral.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            homeStackViewGeral.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }
    
    func setupAddView() {
        homeStackViewText.addArrangedSubview(homeLabelTitle)
        homeStackViewText.addArrangedSubview(HomeLabelName)
        
        homeStackViewGeral.addArrangedSubview(homeStackViewText)
        homeStackViewGeral.addArrangedSubview(HomeButtonSearch)
        homeStackViewGeral.addArrangedSubview(HomeButtonFavorite)
        
        addSubview(homeStackViewGeral)
    }
}
//MARK: - metodos privados
extension HomeHeader {
    @objc private func buttonSearchTapped() {
        delegate?.buttonSearchTapped()
    }
    
    @objc private func buttonFavoriteTapped() {
        delegate?.buttonFavoriteTapped()
    }
}
