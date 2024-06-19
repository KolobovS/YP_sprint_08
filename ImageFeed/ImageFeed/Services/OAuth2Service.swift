import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private weak var task: URLSessionTask?
    private var lastCode: String?
    private var configuration: AuthConfiguration = .standard
    
    private init() { }
    
    func fetchAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        guard var urlComponents = URLComponents(string: configuration.tokenURLString) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "client_secret", value: configuration.secretKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    self?.task = nil
                    handler(.success(responseBody.accessToken))
                case .failure(let error):
                    self?.lastCode = nil
                    handler(.failure(error))
                    URLSession.printError(service: "fetchAuthToken", errorType: "DataError", desc: "Не получен токен")
                }
            }
        }
        task?.resume()
    }
}
