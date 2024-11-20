@testable import ImageFeed
import Foundation

final class MockImagesListService: ImagesListServiceProtocol {
    var photos: [Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    
    init() {
        let url = PhotoURLs(thumb: "", full: "")
        let photosMock = [
            Photo(id: "", createdAt: nil, description: "", urls: url, isLikedByUser: true, size: CGSize(width: 0, height: 0)),
            Photo(id: "", createdAt: nil, description: "", urls: url, isLikedByUser: true, size: CGSize(width: 0, height: 0))
        ]
        photos = photosMock
    }
    
    func getURLQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "", value: "")]
    }
    
    func fetchPhotosNextPage(handler: @escaping (Result<[ImageFeed.PhotoResult], any Error>) -> Void) {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLikedByUser: Bool, _ handler: @escaping (Result<Void, any Error>) -> Void) {
        changeLikeCalled.toggle()
        handler(.success(()))
    }
    
    func prepareForLogout() {
        
    }
}
