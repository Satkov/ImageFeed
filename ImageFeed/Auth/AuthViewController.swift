import UIKit
import WebKit

class AuthViewController: UIViewController {
    let showWebViewSegueIdentifier = "ShowWebView"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            if let webViewViewController = segue.destination as? WebViewViewController {
                webViewViewController.delegate = self
            } else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
        } else {
            prepare(for: segue, sender: sender)
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
        print(code)
        print(":123123123132132")
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
        print("ASasd")
    }
    
    
}
