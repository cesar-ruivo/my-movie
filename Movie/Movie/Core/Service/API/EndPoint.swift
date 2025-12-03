import Foundation

protocol EndPoint {
    var baseURL: URL? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    var parameters: [String: Any]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case invalidResource
    case badStatusCode(code: Int)
}
