//
//  UIView+Extensions.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 23.02.2024.
//

import UIKit

extension UIView {
    func addSubviewWithoutAutoresizingMask(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subView)
    }
}
