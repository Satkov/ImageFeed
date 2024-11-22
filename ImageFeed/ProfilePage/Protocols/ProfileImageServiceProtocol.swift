import UIKit

protocol ProfileImageServiceProtocol: AnyObject {
    var profileImageURL: ProfileImageURL? { get }

    func fetchProfileImage(handler: @escaping (Result<ProfileImageURL, Error>) -> Void)
    func prepareForLogout()
}
