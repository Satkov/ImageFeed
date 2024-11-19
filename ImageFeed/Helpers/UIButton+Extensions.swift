import UIKit

extension UIButton {
    func setupButton(imageName: String, parent: UIView, action: Selector, constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(named: imageName), for: .normal)
        parent.addSubview(self)
        addTarget(nil, action: action, for: .touchUpInside)
        NSLayoutConstraint.activate(constraints)
    }
}
