@testable import ImageFeed
import Foundation

final class ProfileImageServiceFake: ImageFeed.ProfileImageServiceProtocol {
    var profileImageURL: ImageFeed.ProfileImageURL?

    init() {
        let url = "https://images.unsplash.com"
        let imageSizes = ImageFeed.ImagesSizes(small: url, medium: url, large: url)
        profileImageURL = ImageFeed.ProfileImageURL(image: imageSizes)
    }

    func fetchProfileImage(handler: @escaping (Result<ImageFeed.ProfileImageURL, any Error>) -> Void) {

    }

    func prepareForLogout() {

    }

}
