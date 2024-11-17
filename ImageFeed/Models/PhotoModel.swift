import Foundation
import CoreGraphics

struct Photo {
    let id: String
    let createdAt: Date?
    let description: String?
    let urls: PhotoURLs
    var isLikedByUser: Bool
    var size: CGSize
    
    init(dto: PhotoResult) {
        id = dto.id
        createdAt = dto.createdAt
        description = dto.description
        urls = dto.urls
        isLikedByUser = dto.likedByUser
        size = CGSize(width: dto.width, height: dto.height)
    }
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: Date?
    let description: String?
    let urls: PhotoURLs
    var likedByUser: Bool
    var size: CGSize {
        CGSize(width: width, height: height)
    }

}

struct PhotoURLs: Decodable {
    let thumb: String
    let full: String
}
