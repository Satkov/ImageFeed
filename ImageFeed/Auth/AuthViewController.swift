import UIKit
import WebKit

class AuthViewController: UIViewController {
    let showWebViewSegueIdentifier = "ShowWebView"
    let authService = OAuth2Service.shared
    let authStorageToken = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            if let webViewViewController = segue.destination as? WebViewViewController {
                webViewViewController.delegate = self
            } else {
                assertionFailure("LOG: Failed to prepare for \(showWebViewSegueIdentifier)")
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward_button_black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward_button_black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "YP Black")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let oAuthTokenResponseBody):
                    self?.authStorageToken.token = oAuthTokenResponseBody.access_token
                    print("LOG: Token successfully saved.")
                    if let vc = self {
                        self?.delegate?.didAuthenticate(vc)
                    }
                case .failure(let error):
                    assertionFailure("LOG: Failed to fetch token: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
}
