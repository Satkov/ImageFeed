import UIKit

protocol ImageListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func showNextViewController(segue: UIStoryboardSegue , sender: Any?)
    func toggleLikeState(_ indexPath: IndexPath, handler: @escaping (_ state: LikeButtonState) -> Void)
    func fetchPhotosNextPage(indexPath: IndexPath)
    func getNumberOfRows() -> Int
    func calculateHightForCells(indexPath: IndexPath, availableWidth: CGFloat) -> CGFloat 
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
    func configure(_ cell: ImagesListCell, for indexPath: IndexPath, handler: @escaping (_ state: LikeButtonState) -> Void)
}
