import Foundation

class SearchInteractor {
    
    weak var presenter: SearchInteractorToPresenterProtocol?
    private let favoriteService: FavoriteServiceProtocol
    private let networkService: NetworkServiceProtocol
    private var movies: [MovieType: [Movie]] = [:]
    
    init(
        favoriteService: FavoriteServiceProtocol,
        networkService: NetworkServiceProtocol) {
            self.favoriteService = favoriteService
            self.networkService = networkService
        }
    
    func setInteractorToPresenter(_ prenseter: SearchInteractorToPresenterProtocol) {
        self.presenter = prenseter
    }
}
//MARK: - Metodos
extension SearchInteractor: SearchPresenterToInteractorProtocol {
    //MARK: - Logica de favorito
    func isFavorite(type: SearchSection, row: Int) -> Bool {
        guard let movie = getMovie(type: type, row:     row) else { return false }
        return favoriteService.isFavorite(movie: movie)
    }
    
    func toggleFavorite(type: SearchSection, row: Int) {
        guard let movie = getMovie(type: type, row: row) else { return }
        
        let isNowFavorite = favoriteService.toggleFavorite(movie: movie)
        print("Filme \(movie.title) agora é favorito? \(isNowFavorite)")
    }
    
    //MARK: - Pesquisar lista de filmes
    func fetchAllMovieList() {
        let group = DispatchGroup()
        getMoviesList(movie: .nowPlaying, group: group)
        getMoviesList(movie: .popular, group: group)
        getMoviesList(movie: .topRate, group: group)
        
        group.notify(queue: .main) {
            print("Todas as 3 chamadas terminaram")
            self.presenter?.requestDidFinishWithSuccess()
        }
    }
    
    func getNumberOfNowPlayingMovies() -> Int {
        return movies[.nowPlaying]?.count ?? 0
        presenter?.requestDidFinishWithSuccess()
    }
    
    func getNumberOfPopularMovies() -> Int {
        return movies[.popular]?.count ?? 0
        presenter?.requestDidFinishWithSuccess()
    }
    
    func getNumberOfTopRateMovies() -> Int {
        return movies[.topRate]?.count ?? 0
        presenter?.requestDidFinishWithSuccess()
    }
    
    //MARK: -
    func getMovie(type: SearchSection, row: Int) -> Movie? {
        let movieTypeKey: MovieType
        
        switch type {
        case .nowPlaying:
            movieTypeKey = .nowPlaying
        case .popular:
            movieTypeKey = .popular
        case .topRate:
            movieTypeKey = .topRate
        }
        
        guard let movieList = movies[movieTypeKey] else { return nil }
        guard row < movieList.count else { return nil }
        
        return movieList[row]
    }
    
    func requestMovieList() {
        
    }
}

//MARK: - Metodos privado
private extension SearchInteractor {
    private func getMoviesList(movie type: MovieType, group: DispatchGroup) {
        let movie: EndPoint = factoryMovieTypeToMovieEndpoint(movie: type)
        
        group.enter()
        
        networkService.request(endPoint: movie) { (result: Result<MoviesResponse, Error>) in
            self.threatRequest(result: result, in: type, group: group)
        }
    }
    
    private func factoryMovieTypeToMovieEndpoint(movie type: MovieType) -> MovieEndPoint {
        switch type {
        case .nowPlaying:
            return .nowPlaying
        case .topRate:
            return .topRated
        case .popular:
            return .popular
        }
    }
    
    private func threatRequest(result: Result<MoviesResponse, Error>, in key: MovieType, group: DispatchGroup) {
        switch result{
        case .success(let movieResponde):
            let newMovie = movieResponde.results
            self.movies[key] = newMovie
        case .failure(let error):
            print(error)
        }
        group.leave()
    }
}
