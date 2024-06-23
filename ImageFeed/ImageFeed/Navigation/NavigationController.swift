import UIKit

final class NavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        self.setNavigationBarHidden(true, animated: false)
    }
}
    
