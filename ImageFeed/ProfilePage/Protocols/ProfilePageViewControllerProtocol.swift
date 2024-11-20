import Foundation

protocol ProfilePageViewControllerProtocol: AnyObject {
    var presenter: ProfilePagePresenterProtocol? { get set }

    func updateAvatarImage(with url: URL?)
    func updateProfile(name: String, tag: String, bio: String?)
    func showAlert(confirmAction: @escaping (() -> Void))
}
