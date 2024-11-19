import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    
    func getURLQueryItems() -> [URLQueryItem]
    func fetchPhotosNextPage(handler: @escaping (Result<[PhotoResult], Error>) -> Void)
    func changeLike(photoId: String, isLikedByUser: Bool, _ handler: @escaping (Result<Void, Error>) -> Void)
    func prepareForLogout()
}
