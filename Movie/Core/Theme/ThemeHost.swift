import Foundation

class ThemeHost {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
    }
    
    //MARK: - funcoes
    func fetchRemoteTheme(completion: @escaping (AppTheme?) -> Void) {
        guard let url = URL(string: "https://gist.githubusercontent.com/cesar-ruivo/53fc060661d2cc3d6174f27e4d649e5a/raw(apagar)/c48b31e1b089b4a37c5079f0d22273d021c76eeb/theme.json") else {
            print("URL do tema remoto é inválida. Carregando tema local.")
            loadLocalTheme(completion: completion)
            return
        }
        
        let endpoint = GenericEndPoint(baseURL: url)
        
        networkService.request(endPoint: endpoint) { (result: Result<AppTheme, Error>) in
            switch result {
            case .success(let remoteTheme):
                completion(remoteTheme)
                print("Tema remoto carregado com sucesso!")
                
            case .failure(let error):
                print("Falha ao buscar tema remoto: \(error). Carregando tema local.")
                self.loadLocalTheme(completion: completion)
            }
        }
    }
    
    func loadLocalTheme(completion: @escaping (AppTheme?) -> Void) {
        guard let bundle = Bundle.main.url(forResource: "theme", withExtension: "json") else {
                    print("ERRO: theme.json não encontrado.")
                    completion(nil)
                    return }
        
        do {
            let themeData = try Data(contentsOf: bundle)
            let theme = try JSONDecoder().decode(AppTheme.self, from:  themeData)
            
            completion(theme)
            print("Tema carregado com sucesso!")
            
        } catch {
            print("Algo deu errado: \(error)")
            completion(nil)
        }
    }
}
