import Foundation

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func getAvatar()
    func getProfileDetails()
    func logout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.getAvatar()
        }
        getProfileDetails()
        getAvatar()
    }
    
    func getAvatar() {
        guard let profileImageURL = profileImageService.avatarURL, let url = URL(string: profileImageURL) else { return }
        view?.setAvatar(url)
    }
    
    func getProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.setProfileDetails(profile)
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}
