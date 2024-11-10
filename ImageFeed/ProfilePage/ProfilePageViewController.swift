import UIKit
import Kingfisher

final class ProfilePageViewController: UIViewController {

    // MARK: - UI Elements
    private let profileImageView = UIImageView()
    private let exitButton = UIButton()
    private let nameLabel = UILabel()
    private let tagLabel = UILabel()
    private let bioLabel = UILabel()

    // MARK: - Services
    private let profileService = ProfileService.shared
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
        )
    }

    // MARK: - Profile Data
    private func loadProfileData() {
        nameLabel.text = profileService.profile?.fullName
        tagLabel.text = profileService.profile?.username
        bioLabel.text = profileService.profile?.bio
    }

    // MARK: - UI Setup Methods
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
}
