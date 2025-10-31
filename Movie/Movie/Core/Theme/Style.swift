import Foundation
import UIKit

struct TextStyle: Codable {
    let name: String
    let fontName: String
    let size: CGFloat
    let color: String
}

struct ColorStyle: Codable {
    let colorName: String
    let hexadecimal: String
}

struct AppTheme: Codable {
    let textStyles: [TextStyle]
    let colors: [ColorStyle]
}



