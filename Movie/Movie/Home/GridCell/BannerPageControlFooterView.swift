import Foundation
import UIKit

final class BannerPageControlFooterView: UICollectionReusableView {
    private var theme: ThemeManager?
    weak var delegate: BannerPageControlFooterViewDelegate?


    //MARK: - componentes
    lazy var bannerPadding: UIPageControl = {
        let padding = UIPageControl()
        padding.currentPageIndicatorTintColor = theme?.color(named: "brandBlue")
        padding.pageIndicatorTintColor = theme?.color(named: "gray")
        padding.translatesAutoresizingMaskIntoConstraints = false
        
        return padding
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - metodos
    func configure(theme: ThemeManager = .shared, page: Int) {
        self.theme = theme
        setupView()
        bannerPadding.numberOfPages = page
    }
    
}

extension BannerPageControlFooterView: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            bannerPadding.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            bannerPadding.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            bannerPadding.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bannerPadding.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    func setupAddView() {
        addSubview(bannerPadding)
    }
    
    
}
