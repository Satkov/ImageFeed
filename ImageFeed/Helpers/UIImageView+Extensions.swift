import UIKit

extension UIImageView {
    func setupRoundedImageView(radius: CGFloat, parent: UIView, constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = radius
        clipsToBounds = true
        parent.addSubview(self)
        NSLayoutConstraint.activate(constraints)
    }
}
