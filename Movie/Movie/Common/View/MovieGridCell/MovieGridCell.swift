import Foundation
import UIKit

final class MovieGridCell: UICollectionViewCell {
    
    weak var delegate: MovieGridCellDelegate?
    private var theme: ThemeManager?
    
    //MARK: - Componentes visuais
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabelView: UILabel = {
        let view = UILabel()
        let style = theme?.textStyle(named: "title2")
        view.font = style?.font
        view.textColor = style?.color
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var voteLabelView: UILabel = {
        let view = UILabel()
        let style = theme?.textStyle(named: "title4")
        view.font = style?.font
        view.textColor = style?.color
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let style = theme?.color(named: "white")
        
        button.setImage(starImage, for: .normal)
        button.setImage(starFillImage, for: .selected)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    //MARK: - StackView
    private lazy var generalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - init
     override init(frame: CGRect) {
        super.init(frame: frame)
         contentView.backgroundColor = .clear
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        generalStackView.arrangedSubviews.forEach { view in
            generalStackView.removeArrangedSubview(view)
        }
        imageView.image = nil
        titleLabelView.text = nil
        voteLabelView.text = nil
    }
    
    //MARK: - Metodo
    // configure
    func configure(with card: Movie, theme: ThemeManager = .shared) -> Void {
        self.theme = theme
        setupView()
        
        titleLabelView.text = card.title
        let numberFormat = String(format: "%.1f", card.vote_average)
        voteLabelView.text = "NOTA \(numberFormat)"
        guard let finalURL = getCompleteImageURL(from: card.poster_path) else { return }
        
        imageView.loadImage(from: finalURL.absoluteString)
    }
    // pegar imagem
    func getCompleteImageURL(from path: String) -> URL? {
        let baseURL = Enviroment.URLImage
        
        guard let finalURL = baseURL?.appendingPathComponent(path) else { return nil }
        
        return finalURL
    }
    // botao acao
    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }
}

//MARK: - CodeView
extension MovieGridCell: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            generalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            generalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            generalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            generalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier:  1.5),
            
            favoriteButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func setupAddView() {
        generalStackView.addArrangedSubview(imageView)
        generalStackView.addArrangedSubview(titleLabelView)
        generalStackView.addArrangedSubview(voteLabelView)
        
        contentView.addSubview(generalStackView)
        contentView.addSubview(favoriteButton)
    }
}
