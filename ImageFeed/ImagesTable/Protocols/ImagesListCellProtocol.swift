import Foundation

protocol ImagesListCellProtocol: AnyObject {
    static var reuseIdentifier: String { get }
    func configure(with url: URL, photoDate: Date?)
    func setIsLiked(_ state: LikeButtonState)
}
