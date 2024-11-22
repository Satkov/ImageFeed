import UIKit

protocol ProfileServiceProtocol: AnyObject {
    var profile: ProfileInfo? { get }

    func fetchProfile(handler: @escaping (Result<ProfileInfo, Error>) -> Void)
    func prepareForLogout()
}
