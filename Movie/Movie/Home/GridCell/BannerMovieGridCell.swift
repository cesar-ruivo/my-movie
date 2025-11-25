import Foundation
import UIKit

final class BannerMovieGridCell: UICollectionViewCell {
    weak var delegate: BannerMovieGridCellDelegate?
    private var theme: ThemeManager?
    //MARK: - componentes
    private lazy var BannerImageView: GradientImageView = {
        let view = GradientImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.applyGradient(.darkFade)
        
        return view
    }()
    
    private lazy var bannerGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var bannerTitleLabel: UILabel = {
        let label = UILabel()
        let style = theme?.textStyle(named: "title")
        label.font = style?.font
        label.textColor = style?.color
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var BannerDescriptionLabel: UILabel = {
        let label = UILabel()
        let style = theme?.textStyle(named: "title4")
        label.font = style?.font
        label.textColor = style?.color
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var bannerButton: UIButton = {
        let button = UIButton()
        let style = theme?.textStyle(named: "button")
        button.backgroundColor = theme?.color(named: "brandBlue")
        button.setTitle("Veja mais", for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var bannerFavoriteButton: UIButton = {
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
    //MARK: - stackView
    private lazy var bannerTextStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var bannerButtonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.alignment = .center
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - init
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerButtonStackView.arrangedSubviews.forEach { view in
            bannerButtonStackView.removeArrangedSubview(view)
        }
        bannerTextStackView.arrangedSubviews.forEach { view in
            bannerTextStackView.removeArrangedSubview(view)
        }
        
        bannerTitleLabel.text = nil
        BannerDescriptionLabel.text = nil
        BannerImageView.image = nil
    }
    
    
    //MARK: - Metodos
    func configure(theme: ThemeManager = .shared, with card: Movie) {
        self.theme = theme
        setupView()
        
        bannerTitleLabel.text = card.title
        BannerDescriptionLabel.text = card.overview
        guard let finalURL = getCompleteImageURL(from: card.poster_path) else { return  }
        BannerImageView.loadImage(from: finalURL.absoluteString)
    }
    
    func getCompleteImageURL(from path: String) -> URL? {
        let baseURL = Enviroment.URLImage
        
        guard let finalURL = baseURL?.appendingPathComponent(path) else { return nil }
        
        return finalURL
    }
    
    //MARK: - botao acao
    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }
}

extension BannerMovieGridCell: CodeView {
    
    func setupContraints() {
        let aspectConstraint = BannerImageView.heightAnchor.constraint(equalTo: BannerImageView.widthAnchor, multiplier: 0.8)
        aspectConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            bannerTextStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bannerTextStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bannerTextStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            aspectConstraint,
            BannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            BannerImageView.bottomAnchor.constraint(equalTo: bannerTextStackView.topAnchor, constant: -16),
            BannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            BannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            bannerButton.heightAnchor.constraint(equalToConstant: 40),
            bannerFavoriteButton.widthAnchor.constraint(equalToConstant: 32),
            bannerFavoriteButton.heightAnchor.constraint(equalToConstant: 32),

            bannerButtonStackView.leadingAnchor.constraint(equalTo: bannerTextStackView.leadingAnchor),
            bannerButtonStackView.trailingAnchor.constraint(equalTo: bannerTextStackView.trailingAnchor),
        ])
    }

    func setupAddView() {
        bannerTextStackView.addArrangedSubview(bannerTitleLabel)
        bannerTextStackView.addArrangedSubview(BannerDescriptionLabel)

        
        bannerTextStackView.addArrangedSubview(bannerButtonStackView)
        bannerTextStackView.setCustomSpacing(12, after: BannerDescriptionLabel)
        
        bannerButtonStackView.addArrangedSubview(bannerButton)
        bannerButtonStackView.addArrangedSubview(bannerFavoriteButton)
        
        contentView.addSubview(BannerImageView)
        contentView.addSubview(bannerTextStackView)
    }
}

