import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak var dateGradientBackground: UIView!

    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private var cacheCellHeight: [IndexPath: CGFloat] = [:]

    private struct Constants {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .ypBlack        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else {
                assertionFailure("Invalid sender or destination")
                return
            }
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellHeight = cacheCellHeight[indexPath] {
            return cellHeight
        }

        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom

        cacheCellHeight[indexPath] = cellHeight
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: "\(indexPath.row)"),
              let buttonImage = UIImage(named: LikeButtonState.state(for: indexPath.row).rawValue) else { return }

        cell.cellImage.image = image
        cell.cellImage.contentMode = .scaleAspectFill
        cell.dateLabel.text = Date().dateString
        configureDateBackgroundView(for: cell)
        cell.likeButton.setImage(buttonImage, for: .normal)
        cell.selectionStyle = .none
    }

    private func configureDateBackgroundView(for cell: ImagesListCell) {
        if let dateBackgroundView = cell.dateGradientBackgroundView {
            setGradientBackgroundColor(for: dateBackgroundView)
        }
    }
}

enum LikeButtonState: String {
    case off = "like_button_off"
    case on = "like_button_on"

    static func state(for index: Int) -> LikeButtonState {
        return index % 2 == 0 ? .off : .on
    }
}
