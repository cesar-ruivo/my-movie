import UIKit

class MovieDetailViewController: UIViewController {
    //MARK: - Conectar
    private var presenter: MovieDetailViewToPresenterProtocol
    private let theme: ThemeManager
    
    //MARK: - Componentes UI
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentInsetAdjustmentBehavior = .never
        
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backdropImageView: GradientImageView = {
        let image = GradientImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.applyGradient(.darkFade)
        
        return image
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let style = theme.textStyle(named: "title")
        label.font = style?.font.withSize(28)
        label.textColor = style?.color
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        let style = theme.textStyle(named: "title4")
        label.font = style?.font
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        let style = theme.textStyle(named: "title4")
        label.font = style?.font.withSize(16)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        label.attributedText = NSAttributedString(string: " ", attributes: [.paragraphStyle: paragraphStyle])
        
        return label
    }()
    // StackView
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, infoLabel, overviewLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    //MARK: - Inicializador
    init(presenter: MovieDetailViewToPresenterProtocol, theme: ThemeManager = .shared) {
        self.presenter = presenter
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Ciclo de Vida
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "1A1A1A")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        presenter.viewDidLoad()
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapFavorite() {
        presenter.didTapFavorite()
    }
}

extension MovieDetailViewController: CodeView {
    func setupAddView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(textStackView)
        
        view.addSubview(backButton)
        view.addSubview(favoriteButton)
    }
    
    func setupContraints() {
        // Altura da imagem de capa
        let imageHeight: CGFloat = 450
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView (Scrollável)
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // Trava rolagem horizontal
            
            // Imagem de Fundo
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            
            // Botão Voltar (Topo Esquerda)
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Botão Favorito (Topo Direita - Sobre a imagem)
            favoriteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor), // Alinhado com o voltar
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Textos (Abaixo da imagem, com sobreposição visual leve ou logo abaixo)
            textStackView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 24), // Sobe um pouco na imagem
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}

extension MovieDetailViewController: MovieDetailPresenterToViewProtocol {
    func showMovieDetails(title: String, description: String, ratingText: String, imageURL: URL?) {
        titleLabel.text = title
        overviewLabel.text = description
        infoLabel.text = ratingText
        
        if let url = imageURL {
            backdropImageView.loadImage(from: url.absoluteString)
        }
    }
    
    func updateFavoriteIcon(isFavorite: Bool) {
        print("O filme é favorito? \(isFavorite)")
        let iconName = isFavorite ? "star.fill" : "star"
        let color: UIColor = isFavorite ? .systemYellow : .white
        
        favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
        favoriteButton.tintColor = color
    }
}
