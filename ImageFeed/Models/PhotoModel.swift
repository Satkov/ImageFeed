import Foundation
import CoreGraphics

struct Photo: Decodable {
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
