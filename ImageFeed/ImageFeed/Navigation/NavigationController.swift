//
//  NavigationController.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 23.02.2024.
//

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
    
