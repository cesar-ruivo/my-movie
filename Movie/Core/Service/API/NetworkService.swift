import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService {
    func request<T: Decodable>(endPoint: EndPoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let baseURL = endPoint.baseURL?.appendingPathComponent(endPoint.path) else {
            completion(.failure(NetworkError.invalidResource))
            return
        }
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            completion(.failure(NetworkError.invalidResource))
            return
        }
        
        if let parameters = endPoint.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
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
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
                
            } catch {
                print("ERRO DE DECODIFICAÇÃO: \(error)")
                completion(.failure(error))
            }
            
        }.resume()
    }
}

extension NetworkService: NetworkServiceProtocol {
    
}
