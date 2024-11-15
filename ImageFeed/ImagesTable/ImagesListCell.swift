import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    

    @IBOutlet var dateGradientBackgroundView: UIView!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            cellImage.kf.cancelDownloadTask()
        }
    
    @IBAction func likeButtonPressed() {
        delegate?.imageListCellDidTapLike(self)
    }
}
