@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfilePageViewController()
        let presenter = ProfilePagePresenterSpy()
        viewController.configure(presenter)
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.didViewDidLoadCalled)
    }
    
    func testPresenterViewDidLoad() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileServiceFake = ProfileServiceFake()
        let profileImageServiceFake = ProfileImageServiceFake()
        let presenter = ProfilePagePresenter(
            profileService: profileServiceFake,
            profileImageService: profileImageServiceFake
        )
        
        viewController.configure(presenter: presenter)
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.didUpdateAvatarCalled)
        XCTAssertTrue(viewController.didUpdateProfileCalled)
    }
    
    func testDidPresenterCallsShowAlert() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileServiceFake = ProfileServiceFake()
        let presenter = ProfilePagePresenter(profileService: profileServiceFake)
        
        viewController.configure(presenter: presenter)
        
        //when
        presenter.exitButtonTapped()
        
        //then
        XCTAssertTrue(viewController.didShowAlertCalled)
    }

}
