import UIKit
import Kingfisher

final class ImageListPresenter: ImageListPresenterProtocol {

    // MARK: - Properties
    private var photos: [Photo] = []
    private var cellHeightCache = [IndexPath: CGFloat]()
    private var imagesListServiceObserver: NSObjectProtocol?

    var view: ImagesListViewControllerProtocol?
    private var imagesListService: ImagesListServiceProtocol

    // MARK: - Initializer
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }

    deinit {
        removeObserverForImagesList()
    }

    // MARK: - Lifecycle
    func viewDidLoad() {
        photos = imagesListService.photos
        addObserverForImagesList()
    }

    // MARK: - Private Methods
    private func addObserverForImagesList() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkIfNewPhotosWereAdded()
        }
    }

    private func removeObserverForImagesList() {
        if let observer = imagesListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func checkIfNewPhotosWereAdded() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }

    // MARK: - Public Methods
    func configure(_ cell: ImagesListCell, for indexPath: IndexPath, handler: @escaping (_ state: LikeButtonState) -> Void) {
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.urls.thumb) else { return }
        cell.configure(with: url, photoDate: photo.createdAt)
        handler(LikeButtonState.state(for: photo))
    }
    //
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }
    //
    func calculateHightForCells(indexPath: IndexPath, availableWidth: CGFloat) -> CGFloat {
        if let cachedHeight = cellHeightCache[indexPath] {
            return cachedHeight
        }

        let photo = photos[indexPath.row]
        let scaleFactor = availableWidth / CGFloat(photo.size.width)
        let calculatedHeight = CGFloat(photo.size.height) * scaleFactor + Constants.cellInsets.top + Constants.cellInsets.bottom

        cellHeightCache[indexPath] = calculatedHeight
        return calculatedHeight
    }
    //
    func fetchPhotosNextPage(indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage { _ in }
        }
    }

    func getNumberOfRows() -> Int {
        return photos.count
    }
    //
    func toggleLikeState(_ indexPath: IndexPath, handler: @escaping (_ state: LikeButtonState) -> Void) {
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLikedByUser: photo.isLikedByUser) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos[indexPath.row].isLikedByUser.toggle()
                handler(LikeButtonState.state(for: self.photos[indexPath.row]))
            case .failure(let error):
                self.view?.showErrorAlert(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?") { }
                logError(message: "Failed to change like status", error: error)
            }
        }
    }

    func showNextViewController(segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.showSingleImageSegueIdentifier,
              let viewController = segue.destination as? SingleImageViewController,
              let indexPath = sender as? IndexPath else { return }

        UIBlockingProgressHUD.show()
        let photo = photos[indexPath.row]
        guard let url = URL(string: photo.urls.full) else { return }
        view?.loadImage(for: viewController, with: url)
    }
}
