import UIKit

final class ProfileService {
    static let shared = ProfileService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileProviderDidChange")
    private (set) var profile: Profile?
    private var lastToken: String?
    private let lock = NSLock()
    private let semaphore = DispatchSemaphore(value: 0)
    
    func fetchProfile(_ token: String) {
        self.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                self.lock.unlock()
                self.semaphore.signal()
            case .failure(_ ):
                self.lastToken = nil
                self.lock.unlock()
                self.semaphore.signal()
            }
        }
    }
    
    func getProfile() -> Profile? {
        if self.profile == nil {
            self.semaphore.wait()
        }
        return self.profile
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        lock.lock()
        lastToken = token
        
        guard let url = URL(string: "https://api.unsplash.com/me") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) {  (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username, name: "\(profileResult.firstName) \(profileResult.lastName ?? "")", loginName: "@\(profileResult.username)", bio: profileResult.bio ?? "")
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
