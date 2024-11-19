import Foundation

protocol ProfilePagePresenterProtocol: AnyObject {
    var view: ProfilePageViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func prepareAvatarImageURL()
    func exitButtonTapped()
}
