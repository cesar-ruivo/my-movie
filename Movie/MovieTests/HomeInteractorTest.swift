import XCTest
@testable import Movie

final class HomeInteractorTest: XCTestCase {
    private var presenterSpy: HomePresenterSpy = .init()
    private var networkSpy: NetworkServiceSpy = .init()
    
    private lazy var sut: HomeInteractor = {
        let sut: HomeInteractor = .init(networkService: NetworkServiceProtocol.self as! NetworkServiceProtocol)
        return sut
    }()

    
    func test_fetchAllMovieLists_whenAllRequestsSucceed_ShoudNotifyPresenter() {
        let expectation = XCTestExpectation(description: "Esperar o DispatchGroup terminar")
        
        // Ensinamos o PresenterSpy a avisar a Expectativa quando for chamado
        // (Precisamos adicionar um closure no PresenterSpy para isso funcionar, vê abaixo*)
        presenterSpy.onRequestDidFinish = {
            expectation.fulfill() // "Cumpri a expectativa!"
        }
        
        sut.fetchAllMovieLists()
        
        networkSpy.coleteAllRequestsSuccessfully()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(presenterSpy.requestDidFinisWithSuccessCalled, "O interactor deveria ter avisado o presenter depois que tudo terminou")
        XCTAssertEqual(networkSpy.requestCalledCont, 3, "Deveriam ter sido feitas exatamente 3 chamdas de rede")
    }
    
    func test_fetchAllMovieLists_WhenRequestsFail_shoudStilNotifyPrensenter() {
        let expectation = XCTestExpectation(description: "Esperar o dispatchGroup terminar memos com erro")
        
        presenterSpy.onRequestDidFinish = {
            expectation.fulfill()
        }
        
        sut.fetchAllMovieLists()
        
        networkSpy.completeAllRequestWithFailure()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(presenterSpy.requestDidFinisWithSuccessCalled, "O interactor deveria avisar o presenter mesmo se houver erro, para parar o loading")
    }
}

class HomePresenterSpy: HomeInteractorToPresenterProtocol {
    var requestDidFinisWithSuccessCalled = false
    var onRequestDidFinish: (() -> Void)?
    
    func requestDidFinishWithSuccess() {
        requestDidFinisWithSuccessCalled = true
        onRequestDidFinish?()
    }
}
