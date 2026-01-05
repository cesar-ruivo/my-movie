import UIKit

// Cache compartilhado entre todas as imagens
fileprivate let imageCache = NSCache<NSString, UIImage>()

//MARK: - carregar imagem
extension UIImageView {
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        let lastURLUsed = urlString
        
        if let cachedImage: UIImage = imageCache.object(forKey: NSString(string: urlString)) {
            DispatchQueue.main.async {
                if lastURLUsed == urlString {
                    self.image = cachedImage
                }
            }
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let self else { return }
            if let _ = error { return }
            guard let data, let downloadedImage = UIImage(data: data) else { return }
            
            imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
            
            DispatchQueue.main.async {
                if lastURLUsed == urlString {
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}

//MARK: - criar gradient
final class GradientImageView: UIImageView {

    private let gradientLayer = CAGradientLayer()

    struct GradientConfig {
        let hexColors: [String]      
        let locations: [NSNumber]
        let startPoint: CGPoint
        let endPoint: CGPoint
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func applyGradient(_ config: GradientConfig) {

        let uiColors = config.hexColors.compactMap { UIColor(hex: $0) }

        guard uiColors.count == config.hexColors.count else {
            print("Alguns HEX estão inválidos no gradient \(config.hexColors)")
            return
        }

        gradientLayer.colors = uiColors.map { $0.cgColor }
        gradientLayer.locations = config.locations
        gradientLayer.startPoint = config.startPoint
        gradientLayer.endPoint = config.endPoint
    }
}

extension GradientImageView.GradientConfig {
    static var darkFade: Self {
        .init(
            hexColors: ["#00000000", "#1A1A1A"],    // transparente → preto 80%
            locations: [0.4, 1.0],
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint:   CGPoint(x: 0.5, y: 1.0)
        )
    }
}

extension GradientImageView.GradientConfig {
    static var blueMagic: Self {
        .init(
            hexColors: ["#00000000", "#0A1F40FF"],  // transparente → azul profundo
            locations: [0.5, 1.0],
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint:   CGPoint(x: 0.5, y: 1.0)
        )
    }
}
