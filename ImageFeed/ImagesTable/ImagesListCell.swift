import UIKit

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    // MARK: - Static Properties
    static var reuseIdentifier: String {
            return "ImagesListCell"
        }

    // MARK: - Delegate
    weak var delegate: ImagesListCellDelegate?

    // MARK: - Outlets
    @IBOutlet private weak var dateGradientBackgroundView: UIView!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!

    // MARK: - Properties
    private var animationLayers = Set<CALayer>()

    // MARK: - Configuration
    func configure(with url: URL, photoDate: Date?) {
        likeButton.accessibilityIdentifier = "like button"
        configureDateGradientBackground()
        configureImagePlaceholder()
        loadImage(from: url)
        setDateLabel(photoDate)
    }

    func setIsLiked(_ state: LikeButtonState) {
        likeButton.setImage(
            UIImage(named: state.rawValue),
            for: .normal
        )
    }

    // MARK: - Actions
    @IBAction private func likeButtonPressed() {
        delegate?.imageListCellDidTapLike(self)
    }

    // MARK: - Helpers
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        stopGradientAnimation(for: self, animationLayers: &animationLayers)
    }

    private func configureDateGradientBackground() {
        setGradientBackgroundColor(for: dateGradientBackgroundView)
    }

    private func configureImagePlaceholder() {
        setGradientForPlaceholder(
            for: self,
            animationLayers: &animationLayers,
            cornerRadius: 16
        )
        selectionStyle = .none
    }

    private func loadImage(from url: URL) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { [weak self] _ in
            guard let self = self else { return }
            stopGradientAnimation(for: self, animationLayers: &self.animationLayers)
        }
    }

    private func setDateLabel(_ date: Date?) {
        dateLabel.text = date?.dateString ?? ""
    }
}

// MARK: - Like Button State Enum
enum LikeButtonState: String {
    case off = "like_button_off"
    case on = "like_button_on"

    static func state(for photo: Photo) -> LikeButtonState {
        return photo.isLikedByUser ? .on : .off
    }
}
