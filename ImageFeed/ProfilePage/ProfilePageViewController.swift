import UIKit
import Kingfisher

final class ProfilePageViewController: UIViewController {

    // MARK: - UI Elements
    private let profileImageView = UIImageView()
    private let exitButton = UIButton()
    private let nameLabel = UILabel()
    private let tagLabel = UILabel()
    private let bioLabel = UILabel()
    private var animationLayers = Set<CALayer>()
    private var profileDataIsLoaded: Bool = false

    // MARK: - Services
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupProfileImageView()
        setupExitButton()
        setupNameLabel()
        setupTagLabel()
        setupBioLabel()
        loadProfileData()
        addObserverForProfileImage()
        updateAvatarImage()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        activateGradientPlaceholder()
    }

    // MARK: - Configuration
    private func configureView() {
        view.backgroundColor = UIColor(named: "YP Black")
    }

    // MARK: - Observers
    private func addObserverForProfileImage() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateAvatarImage()
        }
    }

    // MARK: - Avatar Image
    private func updateAvatarImage() {
        guard let profileImageURL = ProfileImageService.shared.profileImageURL?.image.large,
              let url = URL(string: profileImageURL) else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 90)
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor)]
        ) { _ in
            self.profileDataIsLoaded = true
            stopGradientAnimation(for: self.profileImageView, animationLayers: &self.animationLayers)
        }
    }

    // MARK: - Profile Data
    private func loadProfileData() {
        nameLabel.text = profileService.profile?.fullName
        tagLabel.text = profileService.profile?.username
        bioLabel.text = profileService.profile?.bio
    }

    // MARK: - UI Setup Methods
    private func activateGradientPlaceholder() {
        if !profileDataIsLoaded {
            setGradientForPlaceholder(for: profileImageView, animationLayers: &animationLayers)
            setGradientForPlaceholder(for: nameLabel, animationLayers: &animationLayers)
            setGradientForPlaceholder(for: bioLabel, animationLayers: &animationLayers)
            setGradientForPlaceholder(for: tagLabel, animationLayers: &animationLayers)
        }
    }

    private func setupProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        view.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setImage(UIImage(named: "exit_button"), for: .normal)
        view.addSubview(exitButton)

        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)
        view.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
    }

    private func setupTagLabel() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.textColor = UIColor(named: "YP Gray")
        tagLabel.font = .systemFont(ofSize: 13)
        view.addSubview(tagLabel)

        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }

    private func setupBioLabel() {
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.textColor = UIColor(named: "YP White")
        bioLabel.font = .systemFont(ofSize: 13)
        view.addSubview(bioLabel)

        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }

    @objc private func exitButtonTapped() {
        let confirmAction = {
            self.profileLogoutService.logout()
            let newViewController = SplashViewController()
            let window = UIApplication.shared.windows.first
            window?.rootViewController = newViewController
            window?.makeKeyAndVisible()
        }
        AlertService.shared.showAlert(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            confirmButtonTitle: "Да",
            cancelButtonTitle: "Нет",
            on: self,
            confirmAction: confirmAction
        )

    }
}
