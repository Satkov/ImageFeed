import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()

    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let requestCacheManager: RequestCacheManagerProtocol
    private let networkTaskManager: NetworkTaskManagerProtocol
    static let didChangeNotification = Notification.Name(rawValue: "PhotoListDidChange")

    private init() {
        networkTaskManager = NetworkTaskManager()
        requestCacheManager = RequestCacheManager.shared
    }

    private enum UnsplashImagesListURL {
        static let photos = "https://api.unsplash.com/photos"
        static func changeLike(id: String) -> String {
            "https://api.unsplash.com/photos/\(id)/like"
        }
    }

    func getURLQueryItems() -> [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: "\((lastLoadedPage ?? 0) + 1)"),
            URLQueryItem(name: "per_page", value: "10")
        ]
    }

    func fetchPhotosNextPage(handler: @escaping (Result<[PhotoResult], Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.fetchPhotosNextPage(handler: handler)
            }
        }

        let cacheKey = "ImagesListService"
        let cacheIdentifier = "\(lastLoadedPage ?? 0)"

        if requestCacheManager.isDuplicateRequest(for: cacheKey, identifier: cacheIdentifier) {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        requestCacheManager.cancelTask(for: cacheKey)

        let urlQueryItems = getURLQueryItems()
        guard let request = makeAuthenticatedRequest(
            for: UnsplashImagesListURL.photos,
            urlQueryItems: urlQueryItems
        ) else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        let updateState: ([PhotoResult]) -> Void = { [weak self] photosDTO in
            var photos: [Photo] = []
            for elem in photosDTO {
                photos.append(elem.createPhotoModel())
            }
            self?.photos.append(contentsOf: photos)
            self?.lastLoadedPage = (self?.lastLoadedPage ?? 0) + 1
            NotificationCenter.default.post(
                name: ImagesListService.didChangeNotification,
                object: self,
                userInfo: ["photos": photos])
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        let task = networkTaskManager.performDecodedRequest(
            request: request,
            updateState: updateState,
            cacheKey: cacheKey,
            decoder: decoder,
            cacheIdentifier: cacheIdentifier,
            handler: handler
        )

        requestCacheManager.setActiveTask(task, for: cacheKey, with: cacheIdentifier)
        task.resume()
    }

    func changeLike(photoId: String, isLikedByUser: Bool, _ handler: @escaping (Result<Void, Error>) -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.changeLike(photoId: photoId, isLikedByUser: isLikedByUser, handler)
            }
        }

        guard var request = makeAuthenticatedRequest(
            for: UnsplashImagesListURL.changeLike(id: photoId)
        ) else {
            handler(.failure(NetworkError.invalidRequest))
            return
        }

        request.httpMethod = isLikedByUser ? "DELETE" : "POST"

        let updateState = {
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                var updatedPhoto = self.photos[index]
                updatedPhoto.isLikedByUser.toggle()
                self.photos[index] = updatedPhoto
            }
        }

        let task = networkTaskManager.performRequest(
            request: request,
            updateState: updateState,
            handler: handler
        )

        task.resume()
    }

    func prepareForLogout() {
        photos = []
    }
}
