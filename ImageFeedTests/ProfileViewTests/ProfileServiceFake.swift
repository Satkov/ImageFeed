@testable import ImageFeed
import Foundation

final class ProfileServiceFake: ProfileServiceProtocol {
    var profile: ImageFeed.ProfileInfo?

    init() {
        profile = ImageFeed.ProfileInfo(firstName: "", username: "", bio: "")
    }

    func fetchProfile(handler: @escaping (Result<ImageFeed.ProfileInfo, any Error>) -> Void) {

    }

    func prepareForLogout() {

    }
}
