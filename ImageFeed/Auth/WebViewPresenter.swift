import Foundation
import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    // MARK: - Initializer
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        loadAuthorizationRequest()
        didUpdateProgressValue(0)
    }
    
    // MARK: - Private Methods
    private func loadAuthorizationRequest() {
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
    }
    
    // MARK: - Public Methods
    func didUpdateProgressValue(_ newValue: Double) {
        let progress = Float(newValue)
        view?.setProgressValue(progress)
        
        let shouldHideProgress = shouldHideProgress(for: progress)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
