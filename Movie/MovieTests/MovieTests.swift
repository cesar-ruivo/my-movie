import XCTest
@testable import Movie // Isso permite que o teste "enxergue" seu app

final class MovieTests: XCTestCase {
    // Variávei para o teste
    private var viewSpy: HomeViewSpy = .init()
    private var interactorSpy: HomeInteractorSpy = .init()
    private var routerSpy: HomeRouterSpy = .init()
    private var homeSectionStorageSpy: HomeSectionStorageSpy = .init()
     
    private lazy var sut: HomePresenter = {
        let sut: HomePresenter = .init(
            interactor: interactorSpy,
            router: routerSpy,
            homeSectionStorage: homeSectionStorageSpy
        )
        sut.setViwToPresenter(viewSpy)

        return sut
    }()
    
    func test_requetMovieList_shoudCallInteractorFetch() {
        // When - chmando a func
        sut.requestMovieList()
        
        // Then - Verificando os dados do espião
        XCTAssertEqual(interactorSpy.fetchAllMovieListsCalledCount, 1, "O presenter Deveria ter mandado o Interactor Buscar os filmes")
    }
    //MARK: - Teste cricao das sessoes
    func test_requestDidFinishWithSuccess_shouldReloadView() {
        interactorSpy.getNumberOfNowPlayingMoviesToBeReturned = 1
        
        sut.requestDidFinishWithSuccess()
        
        XCTAssertTrue(viewSpy.reloadMovieListCalled, "A view deveria ter sido recarregada")
        XCTAssertEqual(interactorSpy.getNumberOfNowPlayingMoviesCount, 1)
        XCTAssertEqual(homeSectionStorageSpy.activeSections, [.nowPlaying])
    }

    func test_requestDidFinishWithSuccess2_shouldReloadView() {
        interactorSpy.getNumberOfNowPlayingMoviesToBeReturned = 1
        interactorSpy.getNumberOfTopRatedMoviesToBeReturned = 1
        
        sut.requestDidFinishWithSuccess()
        
        XCTAssertTrue(viewSpy.reloadMovieListCalled, "A view deveria ter sido recarregada")
        XCTAssertEqual(interactorSpy.getNumberOfNowPlayingMoviesCount, 1)
        XCTAssertEqual(interactorSpy.getNumberOfTopRatedMoviesCount, 1)
        XCTAssertEqual(homeSectionStorageSpy.activeSections, [.nowPlaying, .topRate])
    }
}
//MARK: - Finge ser a tela
class HomeViewSpy: HomePresenterToViewProtocol {
    //cardeno de anotções
    var reloadMovieListCalled = false
    
    func reloadMovieList() {
        reloadMovieListCalled = true
    }
}
//MARK: - finge ser o Interactor
class HomeInteractorSpy: HomePresenterToInteractorProtocol {
    // MARK: - Counts
    var fetchAllMovieListsCalledCount: Int = 0
    var getNumberOfNowPlayingMoviesCount: Int = 0
    var getNumberOfTopRatedMoviesCount: Int = 0
    var getNumberOfPopularMoviesCount: Int = 0

    // MARK: - To be returned
    var getNumberOfNowPlayingMoviesToBeReturned: Int = 0
    var getNumberOfTopRatedMoviesToBeReturned: Int = 0
    var getNumberOfPopularMoviesToBeReturned: Int = 0
    
    func fetchAllMovieLists() {
        fetchAllMovieListsCalledCount += 1
    }
    
    func setInteractorToPresenter(_ presenter: HomeInteractorToPresenterProtocol) { }
    func getNumberOfNowPlayingMovies() -> Int {
        getNumberOfNowPlayingMoviesCount += 1
        return getNumberOfNowPlayingMoviesToBeReturned
    }
    func getNumberOfTopRatedMovies() -> Int {
        getNumberOfTopRatedMoviesCount += 1
        
        return getNumberOfTopRatedMoviesToBeReturned
    }
    func getNumberOfPopularMovies() -> Int {
        getNumberOfPopularMoviesCount += 1
        return getNumberOfPopularMoviesToBeReturned }
    
    func getMovie(type: HomeSections, row: Int) -> Movie? { return nil }
}

class HomeRouterSpy: HomePresenterToRouterProtocol {
    
}

class NetworkServiceSpy: NetworkServiceProtocol {
    var requestCalledCont = 0
    var completions: [(Result<MoviesResponse, Error>) -> Void] = []
    
    func request<T>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        requestCalledCont += 1
        
        if let typedCompletion = completion as? (Result<MoviesResponse, Error>) -> Void {
            completions.append(typedCompletion)
        }
    }
    // Função auxiliar, sucesso em todas as chmadas
    func coleteAllRequestsSuccessfully() {
        let dummyovie = Movie(title: "Teste", overview: "Teste", poster_path: "", vote_average: 10.0)
        let dummResponse = MoviesResponse(page: 1, results: [dummyovie], totalPages: 1, totalResults: 1)
        
        for completion in completions {
            completion(.success(dummResponse))
        }
    }
    // Simular falha internet
    func completeAllRequestWithFailure() {
        let dummyError = NSError(domain: "erro.test", code: -1, userInfo: nil)
        
        for completion in completions {
            completion(.failure(dummyError))
        }
    }
}

class HomeSectionStorageSpy: HomeSectionStorageProtocol {
    var getCount: Int = 0
    var setCount: Int = 0
    var addCount: Int = 0
    
    var activeSections: [HomeSections] = []
    
    func get() -> [HomeSections] {
        getCount += 1
        
        return activeSections
    }
    
    func set(_ sections: [HomeSections]) {
        setCount += 1
        
        activeSections = sections
    }
    
    func add(_ section: HomeSections) {
        addCount += 1
        
        activeSections.append(section)
    }
}
