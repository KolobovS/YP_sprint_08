import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let splashScreenLogo = splashScreenLogo()
        NSLayoutConstraint.activate([
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let token = OAuth2TokenStorage().token {
            DispatchQueue.main.async {
                self.switchToTabBarController()
            }
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { fatalError("Invalid Configuration") }
            authViewController.modalPresentationStyle = .fullScreen
            authViewController.delegate = self
            present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func fetchAuthToken(code: String) {
        OAuth2Service.shared.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    OAuth2TokenStorage().token = accessToken
                    DispatchQueue.main.async {
                        self.switchToTabBarController()
                    }
                case .failure(let error):
                    print("Failed: \(error)")
                    self.dismiss(animated: false)
                    break
                }
            }
        }
    }
}

extension SplashViewController {
    func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func splashScreenLogo() -> UIImageView {
        let splashScreenLogo = UIImageView(image: UIImage(named: "logo_of_unsplash"))
        view.addSubview(splashScreenLogo)
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        
        return splashScreenLogo
    }
}
