@testable import ImageFeed
import Foundation

class ProfilePagePresenterSpy: ProfilePagePresenterProtocol {
    var view: (any ImageFeed.ProfilePageViewControllerProtocol)?
    var didViewDidLoadCalled = false
    
    func viewDidLoad() {
        didViewDidLoadCalled = true
    }
    
    func prepareAvatarImageURL() {
        
    }
    
    func exitButtonTapped() {
        
    }
    
    
}
