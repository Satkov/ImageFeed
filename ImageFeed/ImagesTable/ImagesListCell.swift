import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?

    @IBOutlet private var dateGradientBackgroundView: UIView!
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    private var animationLayers = Set<CALayer>()
    
    func config(url: URL, photoDate: Date?) {
        setGradientBackgroundColor(for: dateGradientBackgroundView)
        setGradientForPlaceholder(for: self, animationLayers: &animationLayers, cornerRadius: 16)
        self.selectionStyle = .none
        self.cellImage.kf.indicatorType = .activity
        self.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { _ in
            stopGradientAnimation(for: self, animationLayers: &self.animationLayers)
        }
        self.dateLabel.text = photoDate?.dateString ?? ""
    }
    
    func setIsLiked(state: LikeButtonState) {
        self.likeButton.setImage(
            UIImage(named: state.rawValue),
            for: .normal
        )
    }

    override func prepareForReuse() {
            super.prepareForReuse()
            cellImage.kf.cancelDownloadTask()
        }

    @IBAction func likeButtonPressed() {
        delegate?.imageListCellDidTapLike(self)
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
