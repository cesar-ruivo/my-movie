import UIKit

class SearchViewController: UIViewController {
    //MARK: - Conectar
    
    private var presenter: SearchViewToPresenterProtocol
    //MARK: - init
    init(presenter: SearchViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - CollectionView
    lazy var collectionView: UICollectionView = {
        let factory = SearchSectionLayoutFactory()
        
        let layout = factory.createLayout(
            onBannerPageChange: {_ in},
            sectionTypeProvider: { [weak self] index in return self?.presenter.getSectionType(for: index) })
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "Section")
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: "TitleHeader")
        
        return collectionView
    }()
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "1A1A1A")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        presenter.requestMovieList()
    }
}
//MARK: - CodeView
extension SearchViewController: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupAddView() {
        view.addSubview(collectionView)
    }
}
//MARK: - Presenter para view
extension SearchViewController: SearchPresenterToViewProtocol {
    func reloadMovieList() {
        collectionView.reloadData()
    }
}
//MARK: - DataSource
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.fetchNumberOfList()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.requestSetionFromList(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = presenter.getSectionType(for: indexPath.section)
        
        switch sectionType {
        case .nowPlaying, .popular, .topRate:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Section",
                for: indexPath
            ) as? MovieGridCell else { return UICollectionViewCell() }
            cell.delegate = self
            
            if let movie = presenter.getMovie(at: indexPath) {
                cell.configure(with: movie)
            }
            
            let isFav = presenter.isFavorite(at: indexPath)
            cell.updateFavoriteState(isFavorite: isFav)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = presenter.getSectionType(for: indexPath.section)
        
        switch sectionType {
        case .nowPlaying, .popular, .topRate:
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "TitleHeader",
                for: indexPath
            ) as? TitleHeaderView else { return UICollectionReusableView() }
            
            let title = presenter.getTitleFromMovies(section: indexPath.section)
            headerSection.configure(text: title)
            
            return headerSection
        }
    }
}
//MARK: - Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = presenter.getSectionType(for: indexPath.section)
        switch sectionType {
        case .nowPlaying, .popular, .topRate:
            return presenter.didSelectMovie(at: indexPath)
        }
    }
}
//MARK: - Grid Delegate
extension SearchViewController: MovieGridCellDelegate {
    func didTapFavoriteButton(in cell: MovieGridCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.toggleFavorite(at: indexPath)
        
        let isFav = presenter.isFavorite(at: indexPath)
        cell.updateFavoriteState(isFavorite: isFav)
    
    }
}
