//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 03.02.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
} 

final class AuthViewController: UIViewController {
    private lazy var unsplashLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UnsplashLogo")
        return imageView
    }()
    private lazy var authButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.imageFeedBlack, for: .normal)
        button.backgroundColor = .imageFeedWhite
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(touchUpInsideAuthButton), for: .touchUpInside)
        button.accessibilityIdentifier = "Authenticate"
        return button
    }()
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthViewController()
    }
    
    private func setupAuthViewController() {
        view.backgroundColor = .imageFeedBlack
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(unsplashLogo)
        view.addSubviewWithoutAutoresizingMask(authButton)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            unsplashLogo.heightAnchor.constraint(equalToConstant: 60),
            unsplashLogo.widthAnchor.constraint(equalToConstant: 60),
            unsplashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            authButton.heightAnchor.constraint(equalToConstant: 48),
            authButton.widthAnchor.constraint(equalToConstant: 343),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsideAuthButton() {
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        let webViewViewController = WebViewViewController()
        webViewViewController.delegate = self
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        self.navigationController?.pushViewController(webViewViewController, animated: true)
    }
}
    
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
