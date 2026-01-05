import Foundation

protocol CodeView {
    func setupContraints()
    func setupAddView()
    func setupView()
}

extension CodeView {
    func setupView() {
        setupAddView()
        setupContraints()
    }
}
