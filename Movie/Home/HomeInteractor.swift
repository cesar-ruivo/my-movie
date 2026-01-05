import Foundation

class HomeInteractor: HomePresenterToInteractorProtocol {
    private weak var presenter: HomeInteractorToPresenterProtocol?
    private var networkService: NetworkServiceProtocol
    private var favoriteService: FavoriteServiceProtocol
    
    init(networkService: NetworkServiceProtocol, favoriteService: FavoriteServiceProtocol) {
        self.networkService = networkService
        self.favoriteService = favoriteService
    }
    
    func setInteractorToPresenter(_ presenter: HomeInteractorToPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: - armazenamento filmes
    private var movies: [MovieType: [Movie]] = [:]
    
    //MARK: - pegar quantidade da lista
    func getNumberOfNowPlayingMovies() -> Int {
        return movies[.nowPlaying]?.count ?? 0
    }
    
    func getNumberOfTopRatedMovies() -> Int {
        return movies[.topRate]?.count ?? 0
    }
    
    func getNumberOfPopularMovies() -> Int {
        return movies[.popular]?.count ?? 0
    }
    
    //MARK: - pergar a lista de filmes da API
    private func getMoviesList(movie type: MovieType, group: DispatchGroup) {
        let movie: EndPoint = factoryMovieTypeToMovieEndpoint(movie: type)
        group.enter()
        networkService.request(endPoint: movie) { (result: Result<MoviesResponse, Error>) in
            self.threatRequest(result: result, in: type, group: group)
        }
    }

    func fetchAllMovieLists() {
        let group = DispatchGroup()
        getMoviesList(movie: .nowPlaying, group: group)
        getMoviesList(movie: .popular, group: group)
        getMoviesList(movie: .topRate, group: group)
        
        group.notify(queue: .main) {
            print("Todas as 3 chamadas terminaram")
            self.presenter?.requestDidFinishWithSuccess()
        }
    }
    // pegar filme para o DataSource
    func getMovie(type: HomeSections, row: Int) -> Movie? {
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
    //MARK: - Favorito
    func toggleFavorite(type: HomeSections, row: Int) -> Bool {
        guard let movie = getMovie(type: type, row: row) else { return false }
        
        let isNowFavorite = favoriteService.toggleFavorite(movie: movie)
        
        print("Filme \(movie.title) agora é favorito? \(isNowFavorite)")
        
        return isNowFavorite
    }
    
    func isFavorite(type: HomeSections, row: Int) -> Bool {
        guard let movie = getMovie(type: type, row: row) else { return false }
        return favoriteService.isFavorite(movie: movie)
    }
    
    func getLocations(for movieID: Int) -> [(section: HomeSections, row: Int)] {
        var locations: [(HomeSections, Int)] = []
        
        if let list = movies[.nowPlaying],
           let index = list.firstIndex(where: { $0.id == movieID }) {
            locations.append((.nowPlaying, index))
        }
        
        if let list = movies[.popular],
           let index = list.firstIndex(where: { $0.id == movieID }) {
            locations.append((.popular, index))
        }
        if let list = movies[.topRate],
           let index = list.firstIndex(where: { $0.id == movieID }) {
            locations.append((.topRate, index))
        }
        
        return locations
    }
}

// MARK: - Metodos privado
private extension HomeInteractor {
    private func threatRequest(result: Result<MoviesResponse, Error>, in key: MovieType, group: DispatchGroup) {
        switch result {
        case .success(let moviesResponse):
            let newMoview = moviesResponse.results
            self.movies[key] = newMoview
            
        case .failure(let error):
            print(error)
         
        }
        group.leave()
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
}
