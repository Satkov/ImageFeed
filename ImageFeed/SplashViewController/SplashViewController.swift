import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    // MARK: - Properties
    
    private let iconView = UIImageView()
    private let showAuthViewControllerIdentifier = "showAuthView"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthenticationStatus()
    }

    // MARK: - Setup UI

    private func setupSplashView() {
        view.backgroundColor = UIColor(named: "YP Black")
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(named: "unsplash_logo")
        view.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Authentication Flow

    private func checkAuthenticationStatus() {
        if KeychainWrapper.standard.string(forKey: KeychainWrapper.keychainKeys.userToken) != nil {
            fetchProfile()
        } else {
            showAuthorizationScreen()
        }
    }

    private func showAuthorizationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("AuthViewController не найден в storyboard")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

// MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        navigationController?.popViewController(animated: true)
        fetchProfile()
    }

    // MARK: - Profile Handling

    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
                self.profileImageService.fetchProfileImage { _ in }
            case .failure(let error):
                assertionFailure("Failed to prepare profile: \(error.localizedDescription)")
            }
        }
    }
}
