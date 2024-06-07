import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Avatar"))
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypGray
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypWhite
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileLogout), for: .touchUpInside)
        button.accessibilityIdentifier = "logout_button"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        self.view.backgroundColor = .ypBlack
        
        if let profile = ProfileService.shared.getProfile() {
            usernameLabel.text = profile.name
            nicknameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
        }
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar(profileImageView)
            }
        updateAvatar(profileImageView)
    }
    
    private func updateAvatar(_ profileImage: UIImageView) {
        profileImage.image = ProfileImageService.shared.avatar.image
    }
    
    @objc
    private func profileLogout() {
        
    }
}

extension ProfileViewController {
    func setConstraints() {
        self.view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        self.view.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
        ])
        
        self.view.addSubview(nicknameLabel)
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
        ])
        
        self.view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
        
        self.view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
}
