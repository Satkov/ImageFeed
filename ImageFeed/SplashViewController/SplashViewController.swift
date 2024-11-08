import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private var iconView = UIImageView()
    private let showAuthViewControllerIdentifier = "showAuthView"
    private let profileService = ProfileService.shared
    private let profileimageService = ProfileImageService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }

    func setupSplashView() {
        view.backgroundColor = UIColor(named: "YP Black")

        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconView)
        let icon = UIImage(named: "unsplash_logo")
        iconView.image = icon

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: KeychainWrapper.keychainKeys.userToken) {
            fetchProfile()
        } else {
            showAuthorizationScreen()
        }
    }

    func showAuthorizationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("AuthViewController не найден в storyboard")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

}

extension SplashViewController {

}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        navigationController?.popViewController(animated: true)
        fetchProfile()
    }

    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success:
                self.switchToTabBarController()
                profileimageService.fetchProfileImage { _ in }
                case .failure(let error):
                assertionFailure("Failed to prepare profile: \(error.localizedDescription)")
            }
        }
    }
}
