import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        let imagesListViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "ImagesListViewController")
        
        imagesListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.standardAppearance.backgroundEffect = nil
        tabBar.backgroundColor = UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 1)
        self.tabBarController?.tabBar.backgroundColor = .ypBlack
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.5)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
}
