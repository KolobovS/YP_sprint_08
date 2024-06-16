import Foundation

class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() { }
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        currentTask?.cancel()
        lastCode = code
        
        let request = makeRequest(code)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.accessToken))
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
                self.currentTask = nil
            }
        }
        currentTask = task
        task.resume()
    }
    
    private func makeRequest(_ code: String) -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("error initial url component")
            return .init(url: URL(fileURLWithPath: ""))
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else {
            print("error initial url component")
            return .init(url: URL(fileURLWithPath: ""))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
