import Foundation

struct GenericEndPoint: EndPoint {
    var baseURL: URL?
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: [String : Any]? = nil 
}
