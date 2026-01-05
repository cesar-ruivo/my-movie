import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Conectar
    var presenter: FavoriteViewToPresenterProtocol
    //MARK: - Componentes UI
    private lazy var favoriteHeader: FavoriteHeader = {
        let view = FavoriteHeader()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    //MARK: - ciclo de vida
    init(presenter: FavoriteViewToPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "1A1A1A")
        navigationController?.setNavigationBarHidden(true, animated: false)
        presenter.requestMovieList()
        setupView()
    }
    //MARK: - collectionView
    lazy var collectionView: UICollectionView = {
        let factory = FavoriteLayoutFactory{ [weak self] indexPath in
            print("Layout: Swipe Delete no index \(indexPath.row)")
            self?.presenter.deleteMovie(at: indexPath)
        }
        
        let layout = factory.createLayout(
            sectionTypeProvider: { [weak self] index in return self?.presenter.getSectionType(for: index) })
            
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FavoriteGridCell.self, forCellWithReuseIdentifier: "Section")
            
        return collectionView
    }()
}

//MARK: - Code View
extension FavoriteViewController: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            favoriteHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favoriteHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: favoriteHeader.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupAddView() {
        view.addSubview(favoriteHeader)
        view.addSubview(collectionView)
    }
}

//MARK: - DataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.fetchNumberOfList()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.requestSectionFromList(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = presenter.getSectionType(for: indexPath.section)
        
        switch sectionType {
        case .favorite:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Section", for: indexPath) as? FavoriteGridCell else { return UICollectionViewCell() }
            cell.delegate = self
            if let movie = presenter.getMovie(at: indexPath) {
                cell.configure(with: movie)
            }
            
            return cell
        }
    }
}

//MARK: - Delegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType = presenter.getSectionType(for: indexPath.section)
        switch sectionType {
        case .favorite:
            return presenter.didSelectMovie(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, trailingSwipeActionsConfigurationForItemAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] ( action, view, completionHandLer) in
            guard let self = self else { return }
            print("View: Swipe Delete no index \(indexPath.row)")
            self.presenter.deleteMovie(at: indexPath)
            completionHandLer(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
//MARK: - Delegate Header
extension FavoriteViewController: FavoriteHeaderProtocol {
    func didTappedButtonBack() {
        presenter.didTappedBackButton()
    }
}

extension FavoriteViewController: FavoriteGridCellDelegateProtocol {
    func didTapDeleteButton(in cell: FavoriteGridCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print("View: Solicitando deleção no index \(indexPath.row)")
        presenter.deleteMovie(at: indexPath)
    }
    
    
}

//MARK: - Presenter para View
extension FavoriteViewController: FavoritePresenterToViewProtocol {
    func reloadMovieList() {
        collectionView.reloadData()
    }
}
