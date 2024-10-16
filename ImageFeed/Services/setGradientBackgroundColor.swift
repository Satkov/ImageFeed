import UIKit

func setGradientBackgroundColor(for view: UIView) {
    let colorTop =  UIColor(red: 0/255.0, green: 149/255.0, blue: 150/255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 58/255.0, green: 94/255.0, blue: 255/255.0, alpha: 1.0).cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds

    view.layer.insertSublayer(gradientLayer, at: 0)
}
