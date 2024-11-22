import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    // MARK: - UI Elements
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var presenter: ImageListPresenterProtocol?

    // MARK: - Configuration
    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter?.showNextViewController(segue: segue, sender: sender)
    }

    // MARK: - Setup
    private func setupTableView() {
        view.backgroundColor = UIColor(named: "YP Black")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "YP Black")
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    // MARK: - Table View Updates
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }

    // MARK: - Image Loading
    func loadImage(for viewController: SingleImageViewControllerProtocol, with url: URL) {
        presenter?.loadImage(for: url) { [weak self] image in
            UIBlockingProgressHUD.dismiss()
            guard let image = image else {
                self?.showErrorAlert(
                    title: "Ошибка",
                    message: "Не удалось загрузить изображение. Повторить попытку?",
                    retryHandler: { [weak self] in
                        self?.loadImage(for: viewController, with: url)
                    }
                )
                return
            }
            viewController.image = image
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let availableWidth = tableView.bounds.width - Constants.cellInsets.left - Constants.cellInsets.right
        return presenter?.calculateHightForCells(indexPath: indexPath, availableWidth: availableWidth) ?? 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotosNextPage(indexPath: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRows() ?? 0
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
        presenter?.configure(cell, for: indexPath) { state in
            cell.setIsLiked(state)
            UIBlockingProgressHUD.dismiss()
        }
        cell.delegate = self
    }
}

// MARK: - Error Handling
extension ImagesListViewController {

    func showErrorAlert(title: String, message: String, retryHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in retryHandler() })
        alertController.addAction(UIAlertAction(title: "Не надо", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCellProtocol) {
        guard let cell = cell as? ImagesListCell,
              let indexPath = tableView.indexPath(for: cell) else { return }

        UIBlockingProgressHUD.show()
        presenter?.toggleLikeState(indexPath) { state in
            cell.setIsLiked(state)
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - Constants
extension Constants {
    static let showSingleImageSegueIdentifier = "ShowSingleImage"
    static let cellInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
    static let defaultRowHeight: CGFloat = 200
}
