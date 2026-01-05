import Foundation

enum MovieEndPoint: EndPoint {
    case search(query: String) // Buscar filmes
    case movieDetails(id: Int)   // Buscar detalhes de um filme
    case popular
    case nowPlaying
    case topRated
    
    var baseURL: URL? { URL(string: "https://api.themoviedb.org/3") }
    var path: String {
        switch self {
            case .search: return "/search/movie"
            case .movieDetails(let id): return "/movie/\(id)"
            case .popular: return "/movie/popular"
            case .nowPlaying: return "/movie/now_playing"
            case .topRated: return "/movie/top_rated"
        }
    }
    var method: HTTPMethod { HTTPMethod.get }
    var parameters: [String: Any]? {
        let apiKey = "681180bf6bed34fdd42fba07b01e78b5"

        switch self {
            case .search(let query): return ["api_key": apiKey, "query": query]
            case .movieDetails, .popular, .nowPlaying, .topRated: return ["api_key": apiKey]

        }
    }
}

