import UIKit

func setGradientBackgroundColor(for view: UIView) {
    let colorTop =  UIColor(red: 255/255.0, green: 149/255.0, blue: 150/255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 58/255.0, green: 94/255.0, blue: 255/255.0, alpha: 1.0).cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds

    view.layer.insertSublayer(gradientLayer, at: 0)
}

func setGradientForPlaceholder(for view: UIView, animationLayers: inout Set<CALayer>, cornerRadius: CGFloat? = nil) {
    let gradient = CAGradientLayer()
    gradient.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height))
    gradient.locations = [0, 0.1, 0.3]
    gradient.colors = [
        UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
        UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
        UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
    ]
    gradient.startPoint = CGPoint(x: 0, y: 0.5)
    gradient.endPoint = CGPoint(x: 1, y: 0.5)
    gradient.cornerRadius = cornerRadius ?? gradient.frame.height / 2
    gradient.masksToBounds = true
    animationLayers.insert(gradient)
    let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
    gradientChangeAnimation.duration = 1.0
    gradientChangeAnimation.repeatCount = .infinity
    gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
    gradientChangeAnimation.toValue = [0, 0.8, 1]
    gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    view.layer.addSublayer(gradient)
}

func stopGradientAnimation(for view: UIView, animationLayers: inout Set<CALayer>) {
    for layer in animationLayers {
        layer.removeAnimation(forKey: "locationsChange")
        layer.removeFromSuperlayer()
    }
    animationLayers.removeAll()
}
