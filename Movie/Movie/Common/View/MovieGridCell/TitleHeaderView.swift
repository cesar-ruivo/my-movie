import Foundation
import UIKit

final class TitleHeaderView: UICollectionReusableView {
    private var theme: ThemeManager?
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        let style = theme?.textStyle(named: "title2")
        view.font = style?.font
        view.textColor = style?.color
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func configure(theme: ThemeManager = .shared, text: String) {
        self.theme = theme
        setupView()
        titleLabel.text = text
    }
}

extension TitleHeaderView: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    func setupAddView() {
        addSubview(titleLabel)
    }
}
