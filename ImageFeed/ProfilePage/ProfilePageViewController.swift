import UIKit
import Kingfisher

final class ProfilePageViewController: UIViewController, ProfilePageViewControllerProtocol {

    // MARK: - UI Elements
    private let profileImageView = UIImageView()
    private let exitButton = UIButton()
    private let nameLabel = UILabel()
    private let tagLabel = UILabel()
    private let bioLabel = UILabel()
    private var animationLayers = Set<CALayer>()
    private var profileDataIsLoaded = false

    // MARK: - Dependencies
    var presenter: ProfilePagePresenterProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        addObserverForProfileImage()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        activateGradientPlaceholder()
    }

    // MARK: - Configuration
    func configure(_ presenter: ProfilePagePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP Black")
        setupProfileImageView()
        setupExitButton()
        setupLabels()
    }

    // MARK: - Observers
    private func addObserverForProfileImage() {
        NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.presenter?.prepareAvatarImageURL()
        }
    }

    // MARK: - Avatar Image
    func updateAvatarImage(with url: URL?) {
        let processor = RoundCornerImageProcessor(cornerRadius: 90)
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor)]
        ) { [weak self] _ in
            self?.profileDataIsLoaded = true
            guard let profileImageView = self?.profileImageView else { return }
            stopGradientAnimation(for: profileImageView, animationLayers: &self!.animationLayers)
        }
    }

    // MARK: - Profile Data
    func updateProfile(name: String, tag: String, bio: String?) {
        nameLabel.text = name
        tagLabel.text = tag
        bioLabel.text = bio
    }

    // MARK: - Exit Action
    @objc private func exitButtonTapped() {
        presenter?.exitButtonTapped()
    }

    func showAlert(confirmAction: @escaping () -> Void) {
        AlertService().showAlert(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            confirmButtonTitle: "Да",
            cancelButtonTitle: "Нет",
            on: self,
            confirmAction: confirmAction
        )
        
    }

    // MARK: - Gradient Placeholder
    private func activateGradientPlaceholder() {
        guard !profileDataIsLoaded else { return }
        [profileImageView, nameLabel, tagLabel, bioLabel].forEach {
            setGradientForPlaceholder(for: $0, animationLayers: &animationLayers)
        }
    }

    // MARK: - UI Setup Methods
    private func setupProfileImageView() {
        profileImageView.setupRoundedImageView(radius: 35, parent: view, constraints: [
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    private func setupExitButton() {
        exitButton.accessibilityIdentifier = "logout button"
        exitButton.setupButton(imageName: "exit_button", parent: view, action: #selector(exitButtonTapped), constraints: [
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupLabels() {
        setupLabel(nameLabel, font: UIFont(name: "SFProDisplay-Bold", size: 23), textColor: "YP White", constraints: [
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
        setupLabel(tagLabel, font: .systemFont(ofSize: 13), textColor: "YP Gray", constraints: [
            tagLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
        setupLabel(bioLabel, font: .systemFont(ofSize: 13), textColor: "YP White", constraints: [
            bioLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }

    private func setupLabel(_ label: UILabel, font: UIFont?, textColor: String, constraints: [NSLayoutConstraint]) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: textColor)
        label.font = font
        view.addSubview(label)
        NSLayoutConstraint.activate(constraints)
    }
}
