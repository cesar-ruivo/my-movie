import Foundation

struct Movie: Codable {
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Double
}

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
