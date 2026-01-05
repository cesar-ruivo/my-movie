import Foundation

class SearchInteractor {
    
    weak var presenter: SearchInteractorToPresenterProtocol?
    private let favoriteService: FavoriteServiceProtocol
    private let networkService: NetworkServiceProtocol
    private var movies: [MovieType: [Movie]] = [:]
    private var moviesSearch: [Movie] = []
    
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
    }
    
    func getNumberOfPopularMovies() -> Int {
        return movies[.popular]?.count ?? 0
    }
    
    func getNumberOfTopRateMovies() -> Int {
        return movies[.topRate]?.count ?? 0
    }
    //MARK: - lista do movieSearch
    func fetchSearch(query: String) {
        let movieSearch: MovieEndPoint = .search(query: query)
        
        networkService.request(endPoint: movieSearch) { (result: Result<MoviesResponse, Error>) in
            switch result {
            case .success(let movieResponde):
                self.moviesSearch = movieResponde.results.filter { $0.poster_path != nil }
                print("Interactor: Busca concluída. Filmes encontrados: \(self.moviesSearch.count)")
                DispatchQueue.main.async {
                    self.presenter?.requestDidFinishWithSuccess()
                }
            case .failure(let error):
                print("Erro na busca: \(error)")
                self.moviesSearch = []
                
                DispatchQueue.main.async {
                    self.presenter?.requestDidFinishWithSuccess()
                }
            }
        }
    }
    
    func getNumberofSearchResults() -> Int {
        return moviesSearch.count
    }
    
    //MARK: -
    func getMovie(type: SearchSection, row: Int) -> Movie? {
        if type == .search {
            guard row < moviesSearch.count else { return nil }
            return moviesSearch[row]
        }
        let movieTypeKey: MovieType
        
        switch type {
        case .nowPlaying:
            movieTypeKey = .nowPlaying
        case .popular:
            movieTypeKey = .popular
        case .topRate:
            movieTypeKey = .topRate
        case .search:
            return nil
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
