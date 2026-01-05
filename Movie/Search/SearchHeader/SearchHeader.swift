import UIKit

final class SearchHeader: UIView {
    private var theme: ThemeManager?
    weak var delegate: SearchHeaderDelegateProtocol?
    //MARK: - compotentes de UI
    private lazy var headerLabelReturn: UILabel = {
        let label = UILabel()
        let style = theme?.textStyle(named: "title3")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.text = "voltar"
        label.font = style?.font
        label.textColor = style?.color
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        let style = theme?.textStyle(named: "title3")
        textField.backgroundColor = theme?.color(named: "gray")
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.textColor = theme?.color(named: "white")
        textField.attributedPlaceholder = NSAttributedString(string: "O que gostaria de assistir?", attributes: [.foregroundColor: UIColor.lightGray])
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .lightGray
        iconView.contentMode = .scaleAspectFit
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        iconContainer.addSubview(iconView)
        
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        
        return textField
    }()
    
    // stackView
    private lazy var headerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [searchTextField, headerLabelReturn])
        view.distribution = .fill
        view.axis = .horizontal
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //MARK: - Ciclo de vida
    init(theme: ThemeManager = ThemeManager.shared) {
        super.init(frame: .zero)
        self.theme = theme
        self.backgroundColor = UIColor.black
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - CodeView
extension SearchHeader: CodeView {
    func setupContraints() {
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            headerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupAddView() {
        addSubview(headerStackView)
    }
}
//MARK: - metodos privados
extension SearchHeader {
    @objc private func labelTapped() {
        delegate?.didTapBackButton()
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        delegate?.didChangeSearchText(text: textField.text ?? "")
    }
}
