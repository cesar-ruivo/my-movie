import UIKit

class HomeViewController: UIViewController, HomePresenterToViewProtocol {
    //MARK: - Conectar
    
    private var presenter: HomeViewToPresenterProtocol
    private var theme: ThemeManager
    private var layoutFactory = HomeLayoutFactory.self
    
    private weak var pageControlFooter: BannerPageControlFooterView?
    
    private var bannerTimer: Timer?
    private var currentBannerIndex: Int = 0
    
    //MARK: - init
    init(presenter: HomeViewToPresenterProtocol, theme: ThemeManager = ThemeManager.shared) {
        self.presenter = presenter
        self.theme = theme
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Componentes
    lazy var collectionView: UICollectionView = {
        let factory = HomeLayoutFactory()
        let layout = factory.createLayout { [weak self] pageIndex in
                    guard let self = self else { return }
                    self.currentBannerIndex = pageIndex
                    self.pageControlFooter?.bannerPadding.currentPage = pageIndex
        }
                    sectionTypeProvider: { [weak self] sectionIndex in
                        return self?.presenter.getSectionType(for: sectionIndex)
                    }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(BannerMovieGridCell.self, forCellWithReuseIdentifier: "BannerCell")
        collectionView.register(BannerPageControlFooterView.self, forSupplementaryViewOfKind: "Footer", withReuseIdentifier: "PageControl")
        
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: "Recomendado")
        collectionView.register(TitleHeaderView.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: "TitleHeader")
        
        return collectionView
    }()
    
    //MARK: - Inicializador
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = UIColor(hex: "1A1A1A")
        
        presenter.requestMovieList()
    }
   
    func reloadMovieList() {
        collectionView.reloadData()
        startBannerTimer()
    }
}

extension HomeViewController: CodeView {
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

//MARK: - DataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.fetchNumberOfList()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.requestSectionFromList(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = presenter.getSectionType(for: indexPath.section)
        
        switch sectionType {
        case .nowPlaying:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerMovieGridCell else { return UICollectionViewCell() }
            if let movie = presenter.getMovie(at: indexPath) {
                cell.configure(with: movie)
            }
            return cell
            
        case .popular, .topRate:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recomendado", for: indexPath) as? MovieGridCell else { return UICollectionViewCell() }
            if let movie = presenter.getMovie(at: indexPath) {
                cell.configure(with: movie)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionType = presenter.getSectionType(for: indexPath.section)
        
        switch sectionType {
        case .nowPlaying:
            guard let footerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PageControl", for: indexPath) as? BannerPageControlFooterView else {
                return UICollectionReusableView()
            }
            
            let sectionPage = presenter.requestSectionFromList(section: indexPath.section)
            footerSection.configure(page: sectionPage)
            self.pageControlFooter = footerSection
                        
            return footerSection
            
        case .popular, .topRate:
            guard let headerSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleHeader", for: indexPath) as? TitleHeaderView else {
                return UICollectionReusableView()
            }
            
            let title = presenter.getTitleFromMovies(section: indexPath.section)
            headerSection.configure(text: title)
            return headerSection
        }
    }
}

//MARK: - Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        stopBannerTimer()
    }
    

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if !collectionView.isDragging && !collectionView.isDecelerating {
            startBannerTimer()
        }
    }
        
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopBannerTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            startBannerTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startBannerTimer()
    }
}

//MARK: - Métodos
extension HomeViewController {
    //MARK: - Timer Banner
    private func startBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(
            timeInterval: 6.0,
            target: self,
            selector: #selector(autoScrollBanner),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }

    @objc private func autoScrollBanner() {
        let total = presenter.requestSectionFromList(section: 0)
        guard total > 0 else { return }
        let nextIndex = (currentBannerIndex + 1) % total
        let nextIndexPath = IndexPath(row: nextIndex, section: 0)
        
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
}
