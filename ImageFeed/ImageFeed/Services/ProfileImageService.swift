import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private weak var task: URLSessionTask?
    private var configuration: AuthConfiguration = .standard
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() { }
    
    func fetchProfileImageURL(username: String, token: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        guard var urlComponents = URLComponents(url: configuration.defaultBaseURL, resolvingAgainstBaseURL: false) else { return }
        urlComponents.path = "/users/\(username)"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    self?.avatarURL = responseBody.profileImage.medium
                    NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": responseBody.profileImage.medium])
                    handler(.success(responseBody.profileImage.medium))
                case .failure(let error):
                    handler(.failure(error))
                    URLSession.printError(service: "fetchProfileImageURL", errorType: "DataError", desc: "Ошибка получения URL аватара профиля")
                }
                self?.task = nil
            }
        }
        task?.resume()
    }
    
    func cleanData() {
        avatarURL = nil
    }
}
