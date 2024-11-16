import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    // MARK: - UI Elements
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    private var photos: [Photo] = []
    private var cellHeightCache = [IndexPath: CGFloat]()
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var animationLayers = Set<CALayer>()

    private struct Constants {
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let cellInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let defaultRowHeight: CGFloat = 200
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addObserverForImagesList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.showSingleImageSegueIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else { return }

        UIBlockingProgressHUD.show()
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.urls.full) else { return }
        loadImage(for: viewController, with: url)
    }

    // MARK: - Setup
    private func setupTableView() {
        view.backgroundColor = UIColor(named: "YP Black")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "YP Black")
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    private func addObserverForImagesList() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        guard oldCount != newCount else { return }

        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    private func loadImage(for viewController: SingleImageViewController, with url: URL) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let value):
                viewController.image = value.image
            case .failure:
                self?.showErrorAlert(
                    title: "Ошибка",
                    message: "Не удалось загрузить изображение. Повторить попытку?",
                    retryHandler: { [weak self] in
                        self?.loadImage(for: viewController, with: url)
                    }
                )
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cachedHeight = cellHeightCache[indexPath] {
            return cachedHeight
        }

        let photo = photos[indexPath.row]
        let availableWidth = tableView.bounds.width - Constants.cellInsets.left - Constants.cellInsets.right
        let scaleFactor = availableWidth / CGFloat(photo.width)
        let calculatedHeight = CGFloat(photo.height) * scaleFactor + Constants.cellInsets.top + Constants.cellInsets.bottom

        cellHeightCache[indexPath] = calculatedHeight
        return calculatedHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage { _ in }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else { return UITableViewCell() }
        configure(imagesListCell, for: indexPath)
        return imagesListCell
    }
}

// MARK: - Cell Configuration
extension ImagesListViewController {

    private func configure(_ cell: ImagesListCell, for indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.urls.thumb) else { return }

        configureDateBackground(for: cell)
        setGradientForPlaceholder(for: cell, animationLayers: &animationLayers, cornerRadius: 16)
        cell.selectionStyle = .none
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { _ in
            stopGradientAnimation(for: cell, animationLayers: &self.animationLayers)
        }
        cell.dateLabel.text = photo.createdAt?.dateString ?? ""
        cell.likeButton.setImage(
            UIImage(named: LikeButtonState.state(for: photo).rawValue),
            for: .normal
        )
        cell.delegate = self
    }

    private func configureDateBackground(for cell: ImagesListCell) {
        guard let dateBackgroundView = cell.dateGradientBackgroundView else { return }
        setGradientBackgroundColor(for: dateBackgroundView)
    }
}

// MARK: - Error Handling
extension ImagesListViewController {

    private func showErrorAlert(title: String, message: String, retryHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in retryHandler() })
        alertController.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]

        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLikedByUser: photo.likedByUser) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success:
                self.photos[indexPath.row].likedByUser.toggle()
                cell.likeButton.setImage(
                    UIImage(named: LikeButtonState.state(for: self.photos[indexPath.row]).rawValue),
                    for: .normal
                )
            case .failure(let error):
                self.showErrorAlert(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?") { }
                logError(message: "Failed to change like status", error: error)
            }
        }
    }
}

// MARK: - Like Button State Enum
enum LikeButtonState: String {
    case off = "like_button_off"
    case on = "like_button_on"

    static func state(for photo: Photo) -> LikeButtonState {
        return photo.likedByUser ? .on : .off
    }
}
