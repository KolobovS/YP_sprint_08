import UIKit
 
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barStyle = .black
        tabBar.backgroundColor = .imageFeedBlack
        tabBar.tintColor = .imageFeedWhite
        
        let imagesListViewPresenter = ImagesListViewPresenter()
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        
        let profileViewPresenter = ProfileViewPresenter()
        let profileViewController = ProfileViewController()
        profileViewController.presenter = profileViewPresenter
        profileViewPresenter.view = profileViewController
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
