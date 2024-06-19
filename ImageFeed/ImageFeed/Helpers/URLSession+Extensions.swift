import Foundation

extension URLSession {
    private enum NetworkError: Error {
        case codeError
        case dataError
    }
    
    func objectTask<T: Decodable>(for request: URLRequest, handler: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                handler(.failure(error))
                URLSession.printError(service: "objectTask", errorType: "NetworkError", desc: "Ошибка подключения к ресурсу")
                return
            }
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                URLSession.printError(service: "objectTask", errorType: "NetworkError", desc: "Код ошибки \(response.statusCode)")
                return
            }
            guard let data = data else {
                handler(.failure(NetworkError.dataError))
                URLSession.printError(service: "objectTask", errorType: "DataError", desc: "Ошибка получения данных")
                return
            }
            do {
                let responseBody = try JSONDecoder().decode(T.self, from: data)
                handler(.success(responseBody))
            } catch {
                handler(.failure(error))
                URLSession.printError(service: "objectTask", errorType: "DataError", desc: "Ошибка преобразования данных в модель")
            }
        })
        return task
    }
    
    static func printError(service: String, errorType: String, desc: String) {
        print("[\(service)]: \(errorType) - \(desc)")
    }
}
