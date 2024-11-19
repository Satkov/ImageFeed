import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var didLoadCalled: Bool = false
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    
    func load(request: URLRequest) {
        didLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
