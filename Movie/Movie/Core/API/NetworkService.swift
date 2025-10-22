import Foundation

class NetworkService {
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        // 1. Criamos a URL base (sem os parâmetros)
        guard let baseURL = endPoint.baseURL?.appendingPathComponent(endPoint.path) else {
                DispatchQueue.main.async { completion(.failure(NetworkError.invalidResource)) }
                return
            }
        
        // 2. Usamos URLComponents para montar a URL final
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
                DispatchQueue.main.async { completion(.failure(NetworkError.invalidResource)) }
                return
            }
        
        // 3. Adicionamos os parâmetros, se existirem
        if let parameters = endPoint.parameters {
                urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
        
        // 4. Pegamos a URL final com os parâmetros incluídos
        guard let finalURL = urlComponents.url else {
            DispatchQueue.main.async { completion(.failure(NetworkError.invalidResource)) }
            return
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = endPoint.method.rawValue
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error { DispatchQueue.main.async { completion(.failure(error)) }; return }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(NetworkError.invalidResource)) }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async { completion(.failure(NetworkError.badStatusCode(code: httpResponse.statusCode))) }
                return
            }
            
            guard let data = data else { DispatchQueue.main.async { completion(.failure(NetworkError.invalidResource)) }; return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                
                DispatchQueue.main.async { completion(.success(result)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
        }.resume()
    }
}

