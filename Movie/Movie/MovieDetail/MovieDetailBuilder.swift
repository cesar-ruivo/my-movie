import Foundation
import UIKit

class MovieDetailBuilder {
    
    // MUDANÇA: O build recebe o 'Movie' selecionado na Home
    static func build(with movie: Movie) -> UIViewController {
        
        // 1. Ferramentas 🛠️
        // (Não precisa de NetworkService aqui se o filme já veio completo,
        //  mas precisa do FavoriteService para salvar)
        let favoriteService = FavoriteService()
        
        // 2. Trabalhador 🧑‍🏭 (Recebe o Filme e o Serviço)
        let interactor = MovieDetailInteractor(movie: movie, favoriteService: favoriteService)
        
        // 3. Roteador 🗺️
        let router = MovieDetailRouter()
        
        // 4. Cérebro 🧠 (Recebe Trabalhador e Roteador)
        let presenter = MovieDetailPresenter(interactor: interactor, router: router)
        
        // 5. Rosto 👀 (Recebe Cérebro)
        let view = MovieDetailViewController(presenter: presenter)
        
        // 6. Conecta os fios soltos 🔌 (Ciclos quebrados)
        interactor.setPresenter(presenter)
        presenter.setView(view)
        router.viewController = view
        
        return view
    }
}
