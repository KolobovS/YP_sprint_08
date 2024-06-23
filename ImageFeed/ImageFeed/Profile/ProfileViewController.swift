import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func setAvatar(_ url: URL)
    func setProfileDetails(_ profile: Profile)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private var userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .imageFeedWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.accessibilityIdentifier = "ProfileNameLabel"
        return label
    }()
    private var loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .imageFeedGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.accessibilityIdentifier = "ProfileLoginLabel"
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .imageFeedWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideExitButton), for: .touchUpInside)
        button.accessibilityIdentifier = "ProfileExitButton"
        return button
    }()
    
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewController()
        presenter?.viewDidLoad()
    }
    
    private func setupProfileViewController() {
        view.backgroundColor = .imageFeedBlack
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(userPhotoImageView)
        view.addSubviewWithoutAutoresizingMask(nameLabel)
        view.addSubviewWithoutAutoresizingMask(loginNameLabel)
        view.addSubviewWithoutAutoresizingMask(descriptionLabel)
        view.addSubviewWithoutAutoresizingMask(exitButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: userPhotoImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    func setAvatar(_ url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        userPhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.jpeg"), options: [.processor(processor)])
    }
    
    func setProfileDetails(_ profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsideExitButton() {
        let yesAction = AlertActionModel(title: "Да") {
            self.presenter?.logout()
        }
        let noAction = AlertActionModel(title: "Нет") {}
        let alertModel = AlertModel(title: "Пока, пока!",
                                    message: "Уверены, что хотите выйти?",
                                    actions: [yesAction, noAction])
        AlertPresenter.show(alertModel: alertModel, delegate: self)
    }
}
