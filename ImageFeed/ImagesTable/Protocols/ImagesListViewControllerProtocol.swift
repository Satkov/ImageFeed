import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func showErrorAlert(title: String, message: String, retryHandler: @escaping () -> Void)
    func updateTableViewAnimated(oldCount: Int, newCount: Int) 
    func loadImage(for viewController: SingleImageViewControllerProtocol, with url: URL)
}
