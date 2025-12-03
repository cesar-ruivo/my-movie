import Foundation

struct GenericEndPoint: EndPoint {
    var baseURL: URL?
    var path: String = "" // O path fica vazio, pois a URL base já é a completa
    var method: HTTPMethod = .get
    var parameters: [String : Any]? = nil // Não precisamos de parâmetros extras
}
