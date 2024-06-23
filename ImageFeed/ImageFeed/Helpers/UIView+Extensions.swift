import UIKit

extension UIView {
    func addSubviewWithoutAutoresizingMask(_ subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subView)
    }
}
