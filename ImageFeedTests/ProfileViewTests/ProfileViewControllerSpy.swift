@testable import ImageFeed
import Foundation


class ProfileViewControllerSpy: ProfilePageViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePagePresenterProtocol)?
    var didUpdateProfileCalled = false
    var didUpdateAvatarCalled = false
    var didShowAlertCalled = false
    
    func configure(presenter: ImageFeed.ProfilePagePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateAvatarImage(with url: URL?) {
        didUpdateAvatarCalled = true
    }
    
    func updateProfile(name: String, tag: String, bio: String?) {
        didUpdateProfileCalled = true
    }
    
    func showAlert(confirmAction: @escaping (() -> Void)) {
        confirmAction()
        didShowAlertCalled = true
    }
    
    
}
