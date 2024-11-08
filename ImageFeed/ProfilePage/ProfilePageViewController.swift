import UIKit
import Kingfisher

final class ProfilePageViewController: UIViewController {
    private var profileImage = UIImageView()
    private var exitButton = UIButton()
    private var nameLabel = UILabel()
    private var tagLabel = UILabel()
    private var bioLabel = UILabel()
    private var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setupProfileImageView()
        setupExitButtonView()
        setupNameLabelView()
        setupTagLabelView()
        setupBioLabelView()
        setupProfileData()
        addObserverProfileImage()
        updateAvatar()
    }
    private func addObserverProfileImage() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL?.image.large,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 90)
        profileImage.kf.setImage(with: url,
                                 placeholder: UIImage(named: "placeholder"),
                                 options: [.processor(processor)])
    }

    func setupProfileData() {
        nameLabel.text = profileService.profile?.fullName
        tagLabel.text = profileService.profile?.username
        bioLabel.text = profileService.profile?.bio
    }
    func setupProfileImageView() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true

        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    func setupExitButtonView() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        let buttonImage = UIImage(named: "exit_button")
        exitButton.setImage(buttonImage, for: .normal)

        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func setupNameLabelView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 23)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8)
        ])
    }

    func setupTagLabelView() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagLabel)
        tagLabel.text = "@ekaterina_nov"
        tagLabel.textColor = UIColor(named: "YP Gray")
        tagLabel.font = .systemFont(ofSize: 13)

        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }

    func setupBioLabelView() {
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioLabel)
        bioLabel.text = "@Hello, world!"
        bioLabel.textColor = UIColor(named: "YP White")
        bioLabel.font = .systemFont(ofSize: 13)

        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }
}
