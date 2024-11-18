import Foundation
import CoreGraphics

struct Photo {
    let id: String
    let createdAt: Date?
    let description: String?
    let urls: PhotoURLs
    var isLikedByUser: Bool
    var size: CGSize
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let urls: PhotoURLs
    var likedByUser: Bool
    
    func createPhotoModel() -> Photo {
        Photo(id: self.id,
              createdAt: self.createdAt,
              description: self.description,
              urls: self.urls,
              isLikedByUser: self.likedByUser,
              size: CGSize(width: self.width, height: self.height))
    }
}

struct PhotoURLs: Decodable {
    let thumb: String
    let full: String
}
