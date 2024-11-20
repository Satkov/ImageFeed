@testable import ImageFeed
import XCTest

final class ImageListViewTests: XCTestCase {
    
    func testViewControllerViewDidAppear() {
        //given
        let mockService = MockImagesListService()
        let presenter = ImageListPresenter(imagesListService: mockService)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController
        
        XCTAssertTrue(viewController != nil )
        viewController?.configure(presenter)
        
        //when
        _ = viewController?.viewDidAppear(true)
        
        //then
        XCTAssertEqual(presenter.getNumberOfRows(), 2)
    }
    
    func testFetchPhotosNextPage() {
        //given
        let mockService = MockImagesListService()
        let presenter = ImageListPresenter(imagesListService: mockService)
        let indexPath = IndexPath(row: -1, section: 0)
        
        //when
        presenter.fetchPhotosNextPage(indexPath: indexPath)
        
        //then
        XCTAssertTrue(mockService.fetchPhotosNextPageCalled)
    }
    
    func testToggleLikeState() {
        //given
        let mockService = MockImagesListService()
        let presenter = ImageListPresenter(imagesListService: mockService)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let expectation = XCTestExpectation(description: "Like state toggled")

        presenter.viewDidLoad()
        
        //when
        presenter.toggleLikeState(indexPath) { state in
            XCTAssertEqual(state, .off)
            XCTAssertTrue(mockService.changeLikeCalled)
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 3.0)
    }
}
