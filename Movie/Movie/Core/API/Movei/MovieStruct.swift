import Foundation

struct Movie: Decodable {
    let title: String
    let overview: String
    let poster_path: String
    let vote_average: Double
}
