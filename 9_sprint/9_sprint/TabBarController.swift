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
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
