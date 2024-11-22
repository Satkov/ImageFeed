import Foundation
import UIKit
import Kingfisher

final class ProfilePagePresenter: ProfilePagePresenterProtocol {
    var view: ProfilePageViewControllerProtocol?
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol

    init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared
    ) {
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.profileImageService = profileImageService
    }

    func viewDidLoad() {
        loadProfileData()
        prepareAvatarImageURL()
    }

    private func loadProfileData() {
        guard let profile = profileService.profile else { return }
            view?.updateProfile(
                name: profile.fullName,
                tag: "@\(profile.username)",
                bio: profile.bio
            )
        }

    func prepareAvatarImageURL() {
        guard let profileImageURL = profileImageService.profileImageURL?.image.large,
              let url = URL(string: profileImageURL) else {
            view?.updateAvatarImage(with: nil)
            return
        }
        view?.updateAvatarImage(with: url)
    }

    func exitButtonTapped() {
        let confirmAction = {
            self.profileLogoutService.logout()
            let newViewController = SplashViewController()
            let window = UIApplication.shared.windows.first
            window?.rootViewController = newViewController
            window?.makeKeyAndVisible()
        }
        view?.showAlert(confirmAction: confirmAction)
    }
}
