import UIKit
import WebKit
import ProgressHUD

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    // MARK: - Properties
    
    let showWebViewSegueIdentifier = "ShowWebView"
    let authService = OAuth2Service.shared
    let authStorageToken = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("LOG: Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward_button_black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward_button_black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor(named: "YP Black")
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        UIBlockingProgressHUD.show()
        // Запрос токена с использованием OAuth2Service
        authService.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    self?.authStorageToken.token = accessToken
                    print("LOG: Token successfully saved.")
                    if let strongSelf = self {
                        strongSelf.delegate?.didAuthenticate(strongSelf)
                    }
                case .failure(let error):
                    assertionFailure("LOG: Failed to fetch token: \(error.localizedDescription)")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        navigationController?.popViewController(animated: true)
    }
}
