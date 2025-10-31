import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    private var theme: AppTheme?
        
    private init(theme: AppTheme? = nil) {
        self.theme = theme
    }
    
    //MARK: - funcoes
    // Cores
    func color(named name: String) -> UIColor? {
        guard let colorStyle = self.theme?.colors.first(where: { $0.colorName == name }) else { return nil }
        let color = UIColor(hex: colorStyle.hexadecimal)
        
        return color
    }
    // Texto
    func textStyle(named name: String ) -> (font: UIFont, color: UIColor)? {
        guard let textStyle = self.theme?.textStyles.first(where: { $0.name == name }) else { return nil }
        
        guard let font = UIFont(name: textStyle.fontName, size: textStyle.size) else { print("Aviso: Fonte '\(textStyle.fontName)' não encontrada."); return nil }
        
        guard let color = self.color(named: textStyle.color) else { print("aviso: cor \(textStyle.color) nao encontrada no tema"); return nil }
        
        return (font: font, color: color)
    }
    
    func setTheme(theme: AppTheme?) {
        self.theme = theme
    }
}
