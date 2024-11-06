import UIKit

final class ProfilePageViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    private var profileImage = UIImageView()
    private var exitButton = UIButton()
    private var nameLabel = UILabel()
    private var tagLabel = UILabel()
    private var bioLabel = UILabel()
    private var profileService = ProfileService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileImageView()
        setupExitButtonView()
        setupNameLabelView()
        setupTagLabelView()
        setupBioLabelView()
        setupProfileData()
    }
    
    func setupProfileData() {
        nameLabel.text = profileService.profile?.fullName
        tagLabel.text = profileService.profile?.username
        bioLabel.text = profileService.profile?.bio
    }
    func setupProfileImageView() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImage)
        profileImage.image = UIImage(named: "profile_photo")

        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }

    func setupExitButtonView() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(exitButton)
        let buttonImage = UIImage(named: "exit_button")
        exitButton.setImage(buttonImage, for: .normal)

        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

    func setupNameLabelView() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
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
        contentView.addSubview(tagLabel)
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
        contentView.addSubview(bioLabel)
        bioLabel.text = "@Hello, world!"
        bioLabel.textColor = UIColor(named: "YP White")
        bioLabel.font = .systemFont(ofSize: 13)

        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }
}
