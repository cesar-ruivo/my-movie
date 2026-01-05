import UIKit
import Foundation

final class FavoriteGridCell: UICollectionViewListCell {
    //MARK: - Conector
    weak var delegate: FavoriteGridCellDelegateProtocol?
    private var theme: ThemeManager?
    
    //MARK: - Componentes de UI
    private lazy var favoriteImageViewPoster: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoriteLabelTitle: UILabel = {
        let view = UILabel()
//        let style = theme?.textStyle(named: "title2")
//        let style = ThemeManager.shared.textStyle(named: "title2")
//        view.font = style?.font
//        view.textColor = style?.color
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoriteLabelRate: UILabel = {
        let view = UILabel()
//        let style = theme?.textStyle(named: "title4")
//        let style = ThemeManager.shared.textStyle(named: "title4")
//        view.font = style?.font
//        view.textColor = style?.color
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var favoriteLabelOverview: UILabel = {
        let view = UILabel()
//        let style = theme?.textStyle(named: "title4")
//        let style = ThemeManager.shared.textStyle(named: "title4")
//        view.font = style?.font
//        view.textColor = style?.color
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
//        button.tintColor = theme?.color(named: "white") ?? .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteAction = UIAction(
            title: "Deletar",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] action in
            print("Botão deletar foi clicado!")
            
            guard let self = self else { return }
            self.delegate?.didTapDeleteButton(in: self)
        }
        
        let menu = UIMenu(
            title: "Opções",
            children: [deleteAction]
        )
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    // StackView
    private lazy var favoriteStackViewMain: UIStackView = {
        let view = UIStackView(arrangedSubviews: [favoriteImageViewPoster, favoriteStackViewMovieInfo, favoriteButton])
        view.alignment = .center
        view.spacing = 16
        view.distribution = .fill
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var favoriteStackViewMovieInfo: UIStackView = {
        let view = UIStackView(arrangedSubviews: [favoriteLabelTitle, favoriteLabelRate, favoriteLabelOverview, UIView()])
        view.alignment = .fill
        view.spacing = 8
        view.distribution = .fill
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - Ciclo de vida
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        contentView.backgroundColor = .clear
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell().updated(for: state)
        backgroundConfig.backgroundColor = .clear
        self.backgroundConfiguration = backgroundConfig
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        favoriteStackViewMain.arrangedSubviews.forEach { view in
//            favoriteStackViewMain.removeArrangedSubview(view)
//        }
//        
//        favoriteStackViewMovieInfo.arrangedSubviews.forEach { view in
//            favoriteStackViewMovieInfo.removeArrangedSubview(view)
//        }
        
        favoriteLabelTitle.text = nil
        favoriteLabelRate.text = nil
        favoriteLabelOverview.text = nil
    }
    
 
}
//MARK: - CodeView
extension FavoriteGridCell: CodeView {
    func setupContraints() {
        let imageHeightConstraint = favoriteImageViewPoster.heightAnchor.constraint(equalToConstant: 160)
        imageHeightConstraint.priority = .init(999)
        
        NSLayoutConstraint.activate([
            favoriteStackViewMain.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteStackViewMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteStackViewMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favoriteStackViewMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            favoriteStackViewMovieInfo.heightAnchor.constraint(equalTo: favoriteImageViewPoster.heightAnchor),
            
            favoriteImageViewPoster.widthAnchor.constraint(equalTo: favoriteImageViewPoster.heightAnchor, multiplier: 0.7),
            imageHeightConstraint,
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupAddView() {
        contentView.addSubview(favoriteStackViewMain)
    }
}
//MARK: - metodos
extension FavoriteGridCell {
    private func setupUI() {
        favoriteLabelTitle.font = ThemeManager.shared.textStyle(named: "title2")?.font
        favoriteLabelTitle.textColor = ThemeManager.shared.textStyle(named: "title2")?.color
        
        favoriteLabelRate.font = ThemeManager.shared.textStyle(named: "title4")?.font
        favoriteLabelRate.textColor = ThemeManager.shared.textStyle(named: "title4")?.color
        
        favoriteLabelOverview.font = ThemeManager.shared.textStyle(named: "title4")?.font
        favoriteLabelOverview.textColor = ThemeManager.shared.textStyle(named: "title4")?.color
        
        favoriteButton.tintColor = ThemeManager.shared.textStyle(named: "white")?.color ?? .white
    }
    
    
    func configure(with card: Movie, theme: ThemeManager = .shared) -> Void {
        self.theme = theme
        setupUI()
        
        favoriteLabelTitle.text = card.title
        favoriteLabelRate.text = "NOTA - \(card.vote_average)"
        favoriteLabelOverview.text = card.overview
        
        guard let path = card.poster_path else {
            favoriteImageViewPoster.image = UIImage(systemName: "photo")
            favoriteImageViewPoster.tintColor = .gray
            return
        }
        guard let finalURL = getCompleteImageURL(from: path) else { return }
        favoriteImageViewPoster.loadImage(from: finalURL.absoluteString)
    }
    
    private func getCompleteImageURL(from path: String) -> URL? {
        let baseURL = Enviroment.URLImage
        
        guard let finalURL = baseURL?.appendingPathComponent(path) else { return nil }
        
        return finalURL
    }
}
