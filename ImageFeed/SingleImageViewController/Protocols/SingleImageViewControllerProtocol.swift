import UIKit

protocol SingleImageViewControllerProtocol: AnyObject {
    var image: UIImage? { get set }
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
}
