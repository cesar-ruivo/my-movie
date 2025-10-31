import Foundation

class NetworkService {
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        // 1. Criamos a URL base (sem os parâmetros)
        guard let baseURL = endPoint.baseURL?.appendingPathComponent(endPoint.path) else {
            completion(.failure(NetworkError.invalidResource))
            return
        }
        
        // 2. Usamos URLComponents para montar a URL final
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(NetworkError.invalidResource))
            return
        }
        
        // 3. Adicionamos os parâmetros, se existirem
        if let parameters = endPoint.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        // 4. Pegamos a URL final com os parâmetros incluídos
        guard let finalURL = urlComponents.url else {
            completion(.failure(NetworkError.invalidResource))
            return
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = endPoint.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResource))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badStatusCode(code: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResource))
                return
            }
            
            print("=========================================")
            print("DADOS BRUTOS RECEBIDOS DA REDE:")
            print(String(data: data, encoding: .utf8) ?? "Não foi possível converter os dados para String")
            print("=========================================")
            
            do {
                // Decodifica o resultado
                let result = try JSONDecoder().decode(T.self, from: data)
                // Envia o sucesso
                completion(.success(result))
                
            } catch {
                // Envia a falha de decodificação
                print("ERRO DE DECODIFICAÇÃO: \(error)")
                completion(.failure(error))
            }
            
        }.resume()
    }
}
